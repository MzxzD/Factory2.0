//
//  ErrorOccured.swift
//  Factoy
//
//  Created by Mateo Došlić on 13/06/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

// MARK: Error Function

func errorOccured(){
    let alert = UIAlertController(title: "Whoops!", message: "Something went wrong ", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay. :(", style: .default, handler: nil))    }

func errorOccured(value: Error){
    let alert = UIAlertController(title: "Whoops!", message: "Something went wrong, Error: \(value)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay. :(", style: .default, handler: nil))
}
func errorOccured(value: String){
    let alert = UIAlertController(title: "Whoops!", message: "Something went wrong, Error: \(value)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay. :(", style: .default, handler: nil))
}
