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
    var realmServise: RealmSerivce!
    
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
                 
                    return NewsData(value: ["title": article.title, "descriptionNews": article.description, "urlToImage": article.urlToImage])
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
    
    func combineLocalWithAPIInfomation(){
        print("combining started")
        self.realmServise = RealmSerivce()
        let favoriteNews = self.realmServise.realm.objects(NewsData.self)
        for (localData) in favoriteNews{
            for(apiData) in newsData {
                if localData.title == apiData.title {
                    apiData.isItFavourite = true
                }
            }
        }
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
        let savingData = newsData[selectedNews]


        self.realmServise = RealmSerivce()

        
        if savingData.isItFavourite {
            print("deleting")
            let specificNews = realmServise.realm.object(ofType: NewsData.self, forPrimaryKey: savingData.title)
            self.realmServise.delete(object: specificNews!)
            savingData.isItFavourite = false
            
        } else {
            print("add to database")
            savingData.isItFavourite = true
            self.realmServise.create(object: savingData)

        }
        

    }
    
}
