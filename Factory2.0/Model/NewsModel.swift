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

struct WrapperArticleData {
    let data: [Article]
    let errorMessage: String?
}

struct WrapperNewsData {
    let data: [NewsData]
    let errorMessage: String?
}

