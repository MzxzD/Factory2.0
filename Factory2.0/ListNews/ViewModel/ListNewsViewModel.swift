import Foundation
import UIKit
import RxSwift
import RealmSwift


class ListNewsViewModel {
    
    fileprivate let newsService:APIRepository
    var newsData: [NewsData] = []
    var successDownloadTime: Date?
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var downloadTrigger = PublishSubject<Bool>()
    var realmServise = RealmSerivce()
    init(newsService:APIRepository) {
        self.newsService = newsService
    }
    
    func initializeObservableDataAPI() -> Disposable{
        print("InitializeObservableDataAPI called!")
        
        let combinedObservable = downloadTrigger.flatMap { [unowned self] (_) -> Observable<(WrapperData<NewsData>, WrapperData<NewsData>)> in
            self.loaderControll.onNext(true)
            let favoriteObserver = self.realmServise.getFavoriteData()
            let downloadObserver = self.newsService.fetchNewsFromAPI()
            
            let unwrappedDownloadObserver = downloadObserver.map({ (wrapperArticleData) -> WrapperData<NewsData> in
                print("wrappedArticle into WrappedNews")
                return WrapperData<NewsData>(data:wrapperArticleData.data.map({ (article) -> NewsData in
                    
                    return NewsData(value: ["title": article.title, "descriptionNews": article.description, "urlToImage": article.urlToImage])
                }), errorMessage: wrapperArticleData.errorMessage )
            })
            
            return Observable.combineLatest(unwrappedDownloadObserver,favoriteObserver)
        }
        return combinedObservable.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (wrappedDownloadedData, wrappedFavoriteData) -> (WrapperData<NewsData>, WrapperData<NewsData>) in
                for (localData) in wrappedFavoriteData.data{
                    for(apiData) in wrappedDownloadedData.data {
                        if localData.title == apiData.title {
                            apiData.isItFavourite = true
                        }
                    }
                }
                return (wrappedDownloadedData, wrappedFavoriteData)
            })
            .subscribe(onNext: { (downloadedNews, favoriteNews) in
                
                    self.newsData = downloadedNews.data
                    self.dataIsReady.onNext(true)
                    self.loaderControll.onNext(false)
      
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
            successDownloadTime = currentTime
        }
    }
    
    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: newsData[selectedNews])
    }
    
    func favoriteButtonPressed(selectedNews: Int){
        print("Favorite this news")
        let savingData = NewsData(value: newsData[selectedNews])
        if savingData.isItFavourite {
            print("deleting")
            self.realmServise.delete(object: savingData)
            newsData[selectedNews].isItFavourite = false
            
        } else {
            print("add to database")
            savingData.isItFavourite = true
            self.realmServise.create(object: savingData)
            newsData[selectedNews].isItFavourite = true
            
        }

    }
}
