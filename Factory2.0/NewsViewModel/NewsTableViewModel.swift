import Foundation
import UIKit
import RxSwift


class NewsTableViewModel {
    
    fileprivate let newsService:NewsDataService
    var newsArray: [NewsData] = []
    var timeDataHasDownloaded: Date?
    var newsSubject = PublishSubject<Bool>()
    var isLoading = Variable(true)
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    private func getNewsFromAPI(){
        
        let newsObserver = newsService.fetchNewsFromAPI()
           _ = newsObserver
           // .subscribe(isLoading.bind(onNext: true))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .map({ (artileArray)  -> [NewsData] in
                return artileArray.map { (news) -> NewsData in
                    return NewsData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (newsArray) in
                self.newsSubject.onNext(true)
                self.isLoading.value = false
                self.newsArray = newsArray
                self.timeDataHasDownloaded = Date()
            }
                //                    , onError: { (<#Error#>) in
                //                    <#code#>
                //                }
            )
    }
    
    // Setting Up timer for new data
    func checkForNewData() {
        let date = Date()
        guard let compareTime = timeDataHasDownloaded?.addingTimeInterval((5*60)) else {
            getNewsFromAPI()
            print("First time...")
            return
        }
        if compareTime > date  {
            print("Nada... Nothing atm...")
            return
        } else {
            print("hueheheheh 3:)")
            getNewsFromAPI()
        }
    }
    
    
}
