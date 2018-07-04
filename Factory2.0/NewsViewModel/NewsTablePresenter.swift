import Foundation
import UIKit
import RxSwift


class NewsTablePresenter {
    
    fileprivate let newsService:NewsDataService
    var newsArray: [NewsData] = []
    var timeDataHasDownloaded: Date?
    var newsSubject = PublishSubject<Bool>()
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    private func getNewsFromAPI(){
        
        let newsObserver = newsService.fetchNewsFromAPI()
           _ = newsObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .map({ (artileArray)  -> [NewsData] in
                return artileArray.map { (news) -> NewsData in
                    return NewsData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newsArray) in
                guard let _self = self else { return }
                _self.newsSubject.onNext(true)
                _self.newsArray = newsArray
                _self.timeDataHasDownloaded = Date()
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
