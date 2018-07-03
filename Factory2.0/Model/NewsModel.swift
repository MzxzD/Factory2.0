import UIKit



// MARK: Properties
struct ArticleResponse: Decodable {
    let status: String
    let source: String
    let sortBy: String
    let articles: [Article]
}

struct Article: Decodable{
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
}

struct NewsViewData {
    
    let title: String
    let description: String
    let urlToImage: String
    
}
