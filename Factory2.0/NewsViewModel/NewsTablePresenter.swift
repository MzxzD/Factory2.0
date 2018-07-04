import Foundation
import UIKit
import RxSwift


class NewsTablePresenter {
    
    fileprivate let newsService:NewsDataService
    var newsArray: [NewsViewData?] = []
    var dataDownloadTimestamp: Date?
    let disposeBag = DisposeBag()
    var newsSubject = PublishSubject<Bool>()
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    private func getNews(){
        
        let newsObserver = newsService.getNews()
        newsObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (artileArray) -> [NewsViewData] in
                return artileArray.map { (news) -> NewsViewData in
                    print(news)
                    return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (newsArray) in
                
                self.newsSubject.onNext(true)
                self.newsArray = newsArray
                let timeSuccess = Date()
                self.dataDownloadTimestamp = timeSuccess
            }
                //                    , onError: { (<#Error#>) in
                //                    <#code#>
                //                }
            )
            
            .disposed(by: disposeBag)
        
    }
    
    // Setting Up timer for new data
    func checkForNewData() {
        let date = Date()
        guard let compareTime = dataDownloadTimestamp?.addingTimeInterval((5*60)) else {
            getNews()
            print("First time...")
            return
        }
        if compareTime > date  {
            print("Nada... Nothing atm...")
            return
        } else {
            print("hueheheheh 3:)")
            getNews()
        }
    }
    
    
}
