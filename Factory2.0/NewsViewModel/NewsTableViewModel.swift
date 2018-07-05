import Foundation
import UIKit
import RxSwift


class NewsTableViewModel {
    
    fileprivate let newsService:NewsDataService
    var newsArray: [NewsData] = []
    var timeDataHasDownloaded: Date?
    var refreshView = PublishSubject<Bool>()
    var isLoading = PublishSubject<Bool>()
 
    var triggerDownload = PublishSubject<Bool>()
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    func dummyDownload() {
        
        self.triggerDownload.onNext(true)
        
    }
    
    func initializeObservableDataAPI() -> Disposable{
        // Treba staviti triggerDownload za prvi puta neka obavi download
        print("InitializeObservableDataAPI called!")
        
        self.isLoading.onNext(true)
        
        let downloadObserver = triggerDownload.flatMap { [unowned self] (_) -> Observable<[Article]> in
            print("Download Observer Initialised!")
            return self.newsService.fetchNewsFromAPI()
        }
        return downloadObserver.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (artileArray)  -> [NewsData] in
                print("Download in Progress")
                return artileArray.map { (news) -> NewsData in
                    return NewsData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .subscribe(onNext: { [unowned self] (newsArray) in
                
                self.refreshView.onNext(true)
                self.isLoading.onNext(false)
                self.newsArray = newsArray
        
            })
        //                , onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>,
        
    }
    
    // Setting Up timer for new data
     func checkForNewData() {
        let currentTime = Date()
        if (timeDataHasDownloaded == nil){
             self.triggerDownload.onNext(true)
            return
        }
        let compareCurrentTimeAndTimeDataHasDownloaded =  timeDataHasDownloaded?.addingTimeInterval((5*60))
        
        
        if compareCurrentTimeAndTimeDataHasDownloaded! > currentTime  {
            print("Nada... Nothing atm...")
            self.triggerDownload.onNext(false)
            return
        } else {
            print("hueheheheh 3:)")
           self.triggerDownload.onNext(true)
        }
    }
    
    
}
