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
    var favoriteistNewsCoordinatorDelegate: OpenSingleNewsDelegate?
    var dataIsReady = PublishSubject<Bool>()
    var realmTrigger = PublishSubject<Bool>()
    var errorOccurd = PublishSubject<Bool>()
    
    func getFavoriteNews() -> Disposable {
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.favoriteNewsData.removeAll()
                    let favoriteNews = self.realmServise.realm.objects(NewsData.self)
                    for element in favoriteNews {
                        if element.isItFavourite == true{
                            self.favoriteNewsData += [NewsData(value: ["title": element.title!, "descriptionNews": element.description, "urlToImage": element.urlToImage!, "isItFavourite": element.isItFavourite])]
                        }
                    }
                    self.dataIsReady.onNext(true)
                }
            })
        return realmObaerverTrigger
    }
    
    func newsSelected(selectedNews: Int) {
        let newData = NewsData(value: favoriteNewsData[selectedNews])
        favoriteistNewsCoordinatorDelegate?.openSingleNews(selectedNews: newData)
    }
    
    func removeDataFromFavorite(selectedNews: Int){
        let savingData = favoriteNewsData[selectedNews]
        if ( self.realmServise.delete(object: savingData) ) {
            self.favoriteNewsData.remove(at: selectedNews)
            self.dataIsReady.onNext(true)
        } else {
            errorOccurd.onNext(true)
        }
        
    }
    
}
