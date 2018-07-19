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
    
    
    func delete(){
        let newData = NewsData(value: newsData)
        self.realmService.delete(object: newData)
        newsData.isItFavourite = false
        
    }
    
    func add() {
        let newData = NewsData(value: newsData)
        self.realmService.create(object: newData)
        newsData.isItFavourite = true
    }
    
    
}

