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
        self.realmServise = RealmSerivce()
        self.favoriteNews = self.realmServise.realm.objects(NewsData.self)
        for element in self.favoriteNews {
            favoriteNewsData += [element]
        }
    }
    
    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
        favoriteistNewsCoordinatorDelegate?.openSingleNews(selectedNews: favoriteNewsData[selectedNews])
    }
    
}
