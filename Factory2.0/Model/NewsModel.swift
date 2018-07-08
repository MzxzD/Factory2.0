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

struct WrapperArticleData {
    let data: [Article]
    let errorMessage: String?
}

struct WrapperNewsData {
    let data: [NewsData]
    let errorMessage: String?
}

