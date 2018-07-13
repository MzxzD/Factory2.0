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

class RealmSerivce {
    
    var realm = try! Realm()
    
    func create<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(object: T){
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
