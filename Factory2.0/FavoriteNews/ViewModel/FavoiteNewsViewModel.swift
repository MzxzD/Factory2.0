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
    var realmServise = RealmSerivce()
    var favoriteNews: Results<NewsData>!
    var favoriteistNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    
    @objc func getFavoriteNews() {
        favoriteNewsData.removeAll()
        self.favoriteNews = self.realmServise.realm.objects(NewsData.self)
        if favoriteNews.count != 0 {
            for element in self.favoriteNews {
                if element.isItFavourite == true{
                    self.favoriteNewsData += [element]
                }
                
            }
        } else {
            errorOccured(value: "No Favorites has been added")
            
        }
    }

    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
        let newData = NewsData(value: favoriteNewsData[selectedNews])
        favoriteistNewsCoordinatorDelegate?.openSingleNews(selectedNews: newData)
    }
    
    func favoriteButtonPressed(selectedNews: Int){
        print("Favorite this news")
        let savingData = NewsData(value: favoriteNewsData[selectedNews])
            print("deleting")
            self.realmServise.delete(object: savingData)
        self.favoriteNewsData.remove(at: selectedNews)
    
    }
}
