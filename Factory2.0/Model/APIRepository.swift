import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

class APIRepository {
    let url = URL(string: "https://newsapi.org/v1/articles?apiKey=91f05f55e0e441699553b373b30eea61&sortBy=top&source=bbc-news")
  
    
    func fetchNewsFromAPI() -> Observable<DataAndErrorWrapper<Article>>{
        
        return RxAlamofire
            
            .data(.get, url!)
            
            .map({ (response) -> DataAndErrorWrapper<Article> in
                
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
                  
                    return DataAndErrorWrapper(data: [], errorMessage: error.localizedDescription)
                }
                print("Download Complete!")
                return DataAndErrorWrapper(data: articles , errorMessage: nil)
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper<Article>> in
                print(error)
                return Observable.just(DataAndErrorWrapper(data: [], errorMessage: error.localizedDescription))
            })
        

       

        
    }
}

