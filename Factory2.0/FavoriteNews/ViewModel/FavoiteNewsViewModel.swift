//
//  FavoiteNewsViewModel.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 15/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//
import Foundation
import RealmSwift
import RxSwift

class FavoritenewsViewModel {
    var favoriteNewsData: [NewsData] = []
    var realmServise = RealmSerivce()
    var favoriteNews: Results<NewsData>!
    var favoriteistNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var dataIsReady = PublishSubject<Bool>()
    var realmTrigger = PublishSubject<Bool>()
    
    func getFavoriteNews() -> Disposable {
        
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.favoriteNewsData.removeAll()
                    self.favoriteNews = self.realmServise.realm.objects(NewsData.self)
                    for element in self.favoriteNews {
                        if element.isItFavourite == true{
                            self.favoriteNewsData += [element]
                        }
                        
                    }
                    self.dataIsReady.onNext(true)
                }
            })
        return realmObaerverTrigger
    }
    
    func newsSelected(selectedNews: Int) {
        print("PushToDetail function initiated")
        let newData = NewsData(value: favoriteNewsData[selectedNews])
        favoriteistNewsCoordinatorDelegate?.openSingleNews(selectedNews: newData)
    }
    
    func removeDataFromFavorite(selectedNews: Int){
        print("Favorite this news")
        let savingData = NewsData(value: favoriteNewsData[selectedNews])
        print("deleting")
        self.realmServise.delete(object: savingData)
        self.favoriteNewsData.remove(at: selectedNews)
        self.dataIsReady.onNext(true)
    }
    
    
}
