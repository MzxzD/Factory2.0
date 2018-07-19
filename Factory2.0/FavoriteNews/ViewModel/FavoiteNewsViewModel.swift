//
//  FavoiteNewsViewModel.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 15/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//
import Foundation
import RealmSwift

class FavoritenewsViewModel {
    var favoriteNewsData: [NewsData] = []
    var realmServise: RealmSerivce!
    var favoriteNews: Results<NewsData>!
    var favoriteistNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    
    @objc func getFavoriteNews() {
        favoriteNewsData.removeAll()
        self.realmServise = RealmSerivce()
        self.favoriteNews = self.realmServise.realm.objects(NewsData.self)
        if favoriteNews.count != 0 {
            for element in self.favoriteNews {
                favoriteNewsData += [element]
            }
        } else {
            errorOccured(value: "No Favorites has been added")
        }
    }

    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
    }
    
    func favoriteButtonPressed(selectedNews: Int){
        print("Favorite this news")
        let savingData = favoriteNewsData[selectedNews]
        self.realmServise = RealmSerivce()
            print("deleting")
            self.realmServise.delete(object: savingData)
    
    }
}
