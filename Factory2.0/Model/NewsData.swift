
import Realm
import RealmSwift

class NewsData: Object {
    
    @objc dynamic var title: String? = ""
    @objc dynamic var descriptionNews: String? = ""
    @objc dynamic var urlToImage: String? = ""
    @objc dynamic var isItFavourite: Bool = false
    
    override static func primaryKey() -> String? {
        return "title"
    }

}
