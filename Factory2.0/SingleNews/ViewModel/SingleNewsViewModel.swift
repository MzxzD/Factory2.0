//
//  NewsDetailPresenter.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 01/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import RxSwift


class SingleNewsViewModel {
    
    weak var listNewsCoordinatorDelegate: OpenSingleNewsDelegate?
    var newsData: NewsData!
    let realmService = RealmSerivce()
    var errorOccured = PublishSubject<Bool>()
    
    func addOrRemoveFromDataBase() -> Bool {
        let newData = NewsData(value: newsData)
        
        if (newData.isItFavourite == true ){
            if (self.realmService.delete(object: newData)) {
                newsData.isItFavourite = false
            }else {
                errorOccured.onNext(true)
            }
            
        } else {
            newData.isItFavourite = true
            if ( self.realmService.create(object: newData)) {
                newsData.isItFavourite = true
            }else {
                errorOccured.onNext(true)
            }
            
        }
        return newsData.isItFavourite
    }
    
}

