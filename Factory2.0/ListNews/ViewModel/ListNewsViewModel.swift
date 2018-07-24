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
    var listNewsCoordinatorDelegate: OpenSingleNewsDelegate?
    var downloadTrigger = PublishSubject<Bool>()
    var realmServise = RealmSerivce()
    
    init(newsService:APIRepository) {
        self.newsService = newsService
    }
    
    func initializeObservableDataAPI() -> Disposable{
        
        let combinedObservable = downloadTrigger.flatMap { [unowned self] (_) -> Observable<(DataAndErrorWrapper<NewsData>, DataAndErrorWrapper<NewsData>)> in
            self.loaderControll.onNext(true)
            let favoriteObserver = self.realmServise.getFavoriteData()
            let downloadObserver = self.newsService.fetchNewsFromAPI()
            
            let unwrappedDownloadObserver = downloadObserver.map({ (wrapperArticleData) -> DataAndErrorWrapper<NewsData> in
                return DataAndErrorWrapper<NewsData>(data:wrapperArticleData.data.map({ (article) -> NewsData in
                    
                    return NewsData(value: ["title": article.title, "descriptionNews": article.description, "urlToImage": article.urlToImage])
                }), errorMessage: wrapperArticleData.errorMessage )
            })
            
            return Observable.combineLatest(unwrappedDownloadObserver,favoriteObserver)
        }
        return combinedObservable.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (wrappedDownloadedData, wrappedFavoriteData) -> (DataAndErrorWrapper<NewsData>) in
                for (localData) in wrappedFavoriteData.data{
                    for(apiData) in wrappedDownloadedData.data {
                        if localData.title == apiData.title {
                            apiData.isItFavourite = true
                        }
                    }
                }
                return (wrappedDownloadedData)
            })
            .subscribe(onNext: { (downloadedNews) in
                if downloadedNews.errorMessage == nil {
                    
                    self.newsData = downloadedNews.data
                    self.dataIsReady.onNext(true)
                    self.loaderControll.onNext(false)
                    
                } else {
                    
                    self.errorOccured.onNext(true)
                }
            })
    }
    
    func compareAPIWithRealm() {
        for apiData in newsData {
            apiData.isItFavourite = false
        }
        
        let favoriteNewsData = self.realmServise.realm.objects(NewsData.self)
        for data in favoriteNewsData{
            for(apiData) in newsData {
                if data.title == apiData.title {
                    apiData.isItFavourite = true
                }
            }
        }
        self.dataIsReady.onNext(true)
    }
    func checkForNewData() {
        let currentTime = Date()
        if (successDownloadTime == nil){
            self.downloadTrigger.onNext(true)
            successDownloadTime = currentTime
            return
        }
        let compareCurrentTimeAndTimeDataHasDownloaded =  successDownloadTime?.addingTimeInterval((5*60))
        if compareCurrentTimeAndTimeDataHasDownloaded! > currentTime  {
            compareAPIWithRealm()
            return
        } else {
            self.downloadTrigger.onNext(true)
            successDownloadTime = currentTime
        }
    }
    
    func newsSelected(selectedNews: Int) {
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: newsData[selectedNews])
    }
    
    func addOrRemoveDataFromDatabase(selectedNews: Int){
        let savingData = NewsData(value: newsData[selectedNews])
        if savingData.isItFavourite {
            if (self.realmServise.delete(object: savingData)){
                self.newsData[selectedNews].isItFavourite = false
            } else {
                errorOccured.onNext(true)
            }
            
        } else {
            savingData.isItFavourite = true
            if ( self.realmServise.create(object: savingData) ) {
                self.newsData[selectedNews].isItFavourite = true
            } else {
                errorOccured.onNext(true)
            }
        }
        self.dataIsReady.onNext(true)
    }
}
