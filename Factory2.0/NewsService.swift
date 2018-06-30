
import Foundation
import Alamofire
import AlamofireImage

class NewsService {
    
    
    func getNews(_ callBack:@escaping([News]) -> Void){

        // Validating URL response
        let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
        var newsArray = [News]()
        Alamofire.request(url)
            .validate()
            .responseJSON
            {
                response in
                
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    
                    // Parsing data
                    let JSON = response.result.value as! [String: Any]
                    let JSONArticles = JSON["articles"] as! NSArray
                    for articles in JSONArticles
                    {
                        // Saving important values
                        let values = articles as! [String: String]
                        let headline = (values["title"] as String?) ?? ""
                        let photoUrl = (values["urlToImage"] as String?) ?? ""
                        let story = (values["description"] as String?) ?? ""
                        
                        let news = News(headline: headline, photoUrl: photoUrl, story: story)
                        newsArray += [news]
                        
                    }
                    
                case .failure(let error):
                    errorOccured(value: error)
                }
                callBack(newsArray)
            }
        
    }
    
}
