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

class RealmSevice {
    
    private  let database:Realm
//    static let
    
    
    init() {
        database = try! Realm()
    }
    
    
//    func getFavoritesFromDB() -> [NewsData] {
////        let results:  [NewsData]  = database.objects(<#T##type: Element.Type##Element.Type#>)
//    }
    
}
