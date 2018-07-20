//
//  NewsDetailPresenter.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 01/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation


class SingleNewsViewModel {
    
    weak var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var newsData: NewsData!
    let realmService = RealmSerivce()
    
    func addOrRemoveFromDataBase() -> Bool {
        let newData = NewsData(value: newsData)
        
        if (newData.isItFavourite == true ){
            self.realmService.delete(object: newData)
            newsData.isItFavourite = false
        } else {
            newData.isItFavourite = true
            self.realmService.create(object: newData)
            newsData.isItFavourite = true
        }
        print(newsData.isItFavourite)
        return newsData.isItFavourite
    }
    
}

