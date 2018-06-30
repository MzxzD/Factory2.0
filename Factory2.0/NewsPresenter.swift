import Foundation
import UIKit

// Treba izbaciti
struct NewsViewData {
    
    let headline: String
    let imageUrl: String
    let story: String
}

protocol NewsView {
    
    func startLoading()
    func fininshLoading()
    func setNews(_ news: [NewsViewData])
    func setEmptyNews()
}

class NewsPresenter {
    
    fileprivate let newsService:NewsService
    fileprivate var newsView:NewsView?
    
    init(newsService:NewsService) {
        self.newsService = newsService
    }
    
    func attachView(_ view:NewsView){
        newsView = view
    }
    
    func detachView(){
        newsView = nil
    }
    
    
    func getNews(){
        self.newsView?.startLoading()
       newsService.getNews{[weak self] news in
            self?.newsView?.fininshLoading()
            if(news.count == 0){
                self?.newsView?.setEmptyNews()
            }else{
                // Proširiti 
                let mappedNews = news.map{
                    // prepraviti u puni naziv
                    return NewsViewData(headline: "\($0.headline)", imageUrl: "\($0.photoUrl)", story: "\($0.story)")
                }
                self?.newsView?.setNews(mappedNews)
            }

        }
        
    }
    // MAknuti i zamjeniti sa provjerom
    // Setting Up timer for new data
    func checkTimer(time: Date) {
        let timeToCompare = time.addingTimeInterval(5)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(timeToCompare.timeIntervalSinceReferenceDate - time.timeIntervalSinceReferenceDate))) {
            self.getNews()
            self.checkTimer(time: Date())
        }
    }
    

    
}
