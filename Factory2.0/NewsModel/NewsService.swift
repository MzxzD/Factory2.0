
import Foundation
import Alamofire
import AlamofireImage

class NewsService {
    
    
    func getNews(_ callBack:@escaping([Article]?) -> Void){

        // Validating URL response
        let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
        var newsArray: [Article] = []
        Alamofire.request(url)
            .validate()
            .responseJSON
            {
                response in
                
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    
                    let decoder = JSONDecoder()
                    let jsonData = response.data
                    
                    // Parsing data
                    do {
                        let data = try decoder.decode(Source.self, from: jsonData!)
                        newsArray = data.articles
                    } catch
                    {
                        callBack(nil)
                    }
                    
                    
                case .failure(let error):
                    errorOccured(value: error)
                }
                callBack(newsArray)
            }
        
    }
    
}
