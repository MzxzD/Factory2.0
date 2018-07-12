import Foundation
import UIKit
import RxSwift


class ListNewsViewModel {
    
    fileprivate let newsService:APIRepository
    var newsData: [NewsData] = []
    var successDownloadTime: Date?
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
     var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var downloadTrigger = PublishSubject<Bool>()
    
    init(newsService:APIRepository) {
        self.newsService = newsService
    }
    
    
    func initializeObservableDataAPI() -> Disposable{
        print("InitializeObservableDataAPI called!")
        
        
        
        let downloadObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<WrapperData<Article>> in
            print("Download Observer Initialised!")
            self.loaderControll.onNext(true)
            return self.newsService.fetchNewsFromAPI()
        }
        
        return downloadObserver.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            
            .map({ (wrapperArticleData) -> WrapperData<NewsData>  in
                print("wrappedArticle into WrappedNews")
                return WrapperData<NewsData>(data:wrapperArticleData.data.map({ (article) -> NewsData in
                   // print("WrappedNews.data save NewsData")
                    return                                                                                     NewsData(title: article.title, description: article.description, urlToImage: article.urlToImage)
                }), errorMessage: wrapperArticleData.errorMessage )
            })

            .subscribe(onNext: { [unowned self] (newsArray) in
                
                if newsArray.errorMessage == nil {
                    
                    self.dataIsReady.onNext(true)
                    self.loaderControll.onNext(false)
                    self.newsData = newsArray.data
                } else {
                    self.dataIsReady.onNext(true)
                    self.errorOccured.onNext(true)
                    print("Error Occured")
                }
            })
    }

    // Setting Up timer for new data
    func checkForNewData() {
        print("ChechForNewData initialised!")
        let currentTime = Date()
        if (successDownloadTime == nil){
            self.downloadTrigger.onNext(true)
            successDownloadTime = currentTime
            print("First time Download")
            return
        }
        let compareCurrentTimeAndTimeDataHasDownloaded =  successDownloadTime?.addingTimeInterval((5*60))
        
        
        if compareCurrentTimeAndTimeDataHasDownloaded! > currentTime  {
            print("still")
            return
        } else {
            print("5minutes has passed, downloading anew.")
            self.downloadTrigger.onNext(true)
        }
    }

    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: newsData[selectedNews])
    }
}
