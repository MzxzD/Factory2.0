//
//  RealmService.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 12/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

class RealmSerivce {
    var realm = try! Realm()
    let errorOccured = PublishSubject<Bool>()
    
    func create<T : NewsData>(object: T) {
        do{
            try realm.write {
                realm.add(object)
            }
        }catch _ {
            self.errorOccured.onNext(true)
        }
    }
    
    func delete<T: NewsData>(object: T){
        do {
            try realm.write {
                realm.delete(realm.objects(NewsData.self).filter("title=%@", object.title!))
            }
            
        } catch _ {
            self.errorOccured.onNext(true)
        }
    }

    func getFavoriteData() -> (Observable<DataAndErrorWrapper<NewsData>>){
        var favoriteNewsData: [NewsData] = []
        let favoriteNews = self.realm.objects(NewsData.self)
        for element in favoriteNews {
            favoriteNewsData += [element]
        }
        return Observable.just(DataAndErrorWrapper(data: favoriteNewsData, errorMessage: nil))
    }
}
