import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

class NewsDataService {
    let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
    let urlm = URL(string: "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news")
    //    var news: [Article] = []
    let disposeBag = DisposeBag()
    
    
    func getNews() -> Observable<[Article]>{
        
        return RxAlamofire
            
            .data(.get, urlm!)

            .map({ (response) -> [Article] in
                
                let decoder = JSONDecoder()
                var articles: [Article] = []
                let responseJSON = response
                print(responseJSON)
                 do {
                    let data = try decoder.decode(ArticleResponse.self, from: responseJSON)
                    articles = data.articles
                } catch
                {
                    print("Error")
                }
                return articles
            })
        
    }
}

