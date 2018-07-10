//
//  NewsDetailPresenter.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 01/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation

protocol DataView {
    
}

class NewsViewModel {
    
    fileprivate var newsView: DataView?
    //weak var delegate: NewsCoordinatorDelegate? 
    var newsData: NewsData!
    
    func attachView(_ view: DataView){
        newsView = view
    }
}
