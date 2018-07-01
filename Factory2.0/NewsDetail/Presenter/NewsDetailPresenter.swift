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

class NewsDetailPresenter {
    
    fileprivate var newsDetailView: DataView?
    
    var newsDetailData: NewsViewData!
    
    func attachView(_ view: DataView){
        newsDetailView = view
    }
}
