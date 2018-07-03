import Foundation
import UIKit
import RxSwift

protocol NewsView {
    
    func startLoading()
    func fininshLoading()
    func setNews()
    func setEmptyNews()
}

class NewsTablePresenter {
    
    fileprivate let newsService:NewsDataService
    fileprivate var newsView:NewsView?
    var newsArray: [NewsViewData?] = []
    var dataDownloadTimestamp: Date?
    let disposeBag = DisposeBag()
    
    init(newsService:NewsDataService) {
        self.newsService = newsService
    }
    
    func attachView(_ view:NewsView){
        newsView = view
    }
    
    func detachView(){
        newsView = nil
    }
    
    
//    func parsingData(news: [Article] ) -> [NewsViewData]{
//        let mappedNews = news.map { (news) -> NewsViewData in
//            return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
//        }
//        return(mappedNews)
//    }
    
    
   private func getNews(){
        self.newsView?.startLoading()
   
            let newsObservable = newsService.getNews()
            newsObservable
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .map({ (artileArray) -> [NewsViewData] in
                   return artileArray.map { (news) -> NewsViewData in
                        return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                    }
                })
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (newsArray) in
                    self.newsArray = newsArray
                self.newsView?.setNews()
                let timeSuccess = Date()
                self.dataDownloadTimestamp = timeSuccess
                }
//                    , onError: { (<#Error#>) in
//                    <#code#>
//                }
                )
                .disposed(by: disposeBag)
    
    
//    news.subscribe(onNext: {
//
//
//    } )
//            self.newsView?.fininshLoading()
//            if(news.count == 0){
//                self.newsView?.setEmptyNews()
//            }else{
//                self.newsArray = (self.parsingData(news: news))
//                self.newsView?.setNews()
//                let timeSuccess = Date()
//                self.dataDownloadTimestamp = timeSuccess
//            }
//
//
//
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
