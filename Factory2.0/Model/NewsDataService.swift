import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

class NewsDataService {
    let url = "https://newsapi.org/v2/everything?sources=bbc-news&apiKey=68e78694cad14600b6db78a39e51f374"
    let urlm = URL(string: "https://newsapi.org/v1/articles?apiKey=91f05f55e0e441699553b373b30eea61&sortBy=top&source=bbc-news")
  
    
    func fetchNewsFromAPI() -> Observable<WrapperArticleData>{
        
        return RxAlamofire
            
            .data(.get, urlm!)
            
            .map({ (response) -> WrapperArticleData in
                
                print("Downloading Data")
                let decoder = JSONDecoder()
                var articles: [Article] = []
                let responseJSON = response
                print(responseJSON)
                do {
                    let data = try decoder.decode(ArticleResponse.self, from: responseJSON)
                    print("Decoding data")
                    articles = data.articles
                } catch let error
                {
                    print(error)
                    return WrapperArticleData(data: [], errorMessage: error.localizedDescription)
                }
                print("Download Complete!")
                return WrapperArticleData(data: articles, errorMessage : nil)
            })
            .catchError({ (error) -> Observable<WrapperArticleData> in
                print(error)
                return Observable.just(WrapperArticleData(data: [], errorMessage : error.localizedDescription))
            })
        

       

        
    }
}

