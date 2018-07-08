import Foundation
import UIKit
import RxSwift


class NewsTableViewModel {
    
    fileprivate let newsService:NewsDataService
    var newsArray: [NewsData] = []
    var timeDataHasDownloaded: Date?
    var refreshView = PublishSubject<Bool>()
    var isLoading = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    
    
    var triggerDownload = PublishSubject<Bool>()
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    
    func initializeObservableDataAPI() -> Disposable{
        print("InitializeObservableDataAPI called!")
        
        
        
        let downloadObserver = triggerDownload.flatMap { [unowned self] (_) -> Observable<WrapperArticleData> in
            print("Download Observer Initialised!")
            self.isLoading.onNext(true)
            return self.newsService.fetchNewsFromAPI()
        }
        
        return downloadObserver.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            
            .map({ (wrapperArticleData) -> WrapperNewsData  in
                print("wrappedArticle into WrappedNews")
                return WrapperNewsData(data:wrapperArticleData.data.map({ (article) -> NewsData in
                    print("WrappedNews.data save NewsData")
                    return NewsData(title: article.title, description: article.description, urlToImage: article.urlToImage)
                }), errorMessage: wrapperArticleData.errorMessage )
            })
//            .map({ (wrapperNewsData) -> [NewsData] in
//                return wrapperNewsData.data
//            })

            
            
            
            .subscribe(onNext: { [unowned self] (newsArray) in
                
                if newsArray.errorMessage == nil {
                    
                    self.refreshView.onNext(true)
                    self.isLoading.onNext(false)
                    self.newsArray = newsArray.data
                } else {
                    self.errorOccured.onNext(true)
                    print("Error Occured")
                }
            })
    }
    
    // Setting Up timer for new data
    func checkForNewData() {
        print("ChechForNewData initialised!")
        let currentTime = Date()
        if (timeDataHasDownloaded == nil){
            self.triggerDownload.onNext(true)
            timeDataHasDownloaded = currentTime
            print("First time Download")
            return
        }
        let compareCurrentTimeAndTimeDataHasDownloaded =  timeDataHasDownloaded?.addingTimeInterval((5*60))
        
        
        if compareCurrentTimeAndTimeDataHasDownloaded! > currentTime  {
            print("still")
            return
        } else {
            print("5minutes has passed, downloading anew.")
            self.triggerDownload.onNext(true)
        }
    }
    
    
}
