import UIKit



// MARK: Properties
struct ArticleResponse: Decodable {
    let status: String
    let sortBy: String
    let source: String
    let articles: [Article]
}

struct Article: Decodable{
 
   // let source: [Name]
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String?
}
struct Name: Decodable {
    let id: String
    let name: String
}


struct WrapperData<T> {
    let data: [T]
    let errorMessage: String?
}


