import Foundation
import UIKit

// Treba izbaciti - trebati ce mi pomoc oko toga
struct NewsViewData {

    let title: String
    let description: String
    let urlToImage: String
}

protocol NewsView {
    
    func startLoading()
    func fininshLoading()
    func setNews()
    func setEmptyNews()
}

class NewsPresenter {
    
    fileprivate let newsService:NewsService
    fileprivate var newsView:NewsView?
    var newsArray: [NewsViewData?] = []
    var time = Date()
    
    init(newsService:NewsService) {
        self.newsService = newsService
    }
    
    func attachView(_ view:NewsView){
        newsView = view
    }
    
    func detachView(){
        newsView = nil
    }
    
    
    func parsingData(news: [Article] ) -> [NewsViewData]{
        let mappedNews = news.map { (news) -> NewsViewData in
            return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
        }
        return(mappedNews)
    }
    
    
    func getNews(){
        self.newsView?.startLoading()
        newsService.getNews{[weak self] news in
            self?.newsView?.fininshLoading()
            if(news?.count == 0){
                self?.newsView?.setEmptyNews()
            }else{
                self?.newsArray = (self?.parsingData(news: news!))!
                self?.newsView?.setNews()
                let timeSuccess = Date()
                self?.time = timeSuccess
            }
            
        }
        
    }
    
    // Setting Up timer for new data
    
    func checkTimer() {
        let date = Date()
        let compareTime = time.addingTimeInterval((5*60))
        if compareTime > date  {
            print("Nada... Nothing atm...")
            return
        } else {
            print("hueheheheh 3:)")
            getNews()
        }
    }

    
}
