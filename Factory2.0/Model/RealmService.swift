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
    
    func create<T : NewsData>(object: T) {
        try! realm.write {
            realm.add(object)
            
            
        }
    }
    
    func delete<T: NewsData>(object: T){
        
        try! realm.write {
           
            realm.delete(object)
        }
        
        
    }
}
