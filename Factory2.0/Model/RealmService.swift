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
    var realmServiceIsDone = PublishSubject<Bool>()
    
    func create<T : Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
                
            }
        } catch let error{
            print(error.localizedDescription)
//            self.realmServiceIsDone.onError()
        }
        self.realmServiceIsDone.onNext(true)
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
