//
//  NewsListCoordinatorDelegate.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation

protocol NewsTableCoordinatorDelegate: CoordinatorDelegate {
    func openDetailNews(selectedNews: NewsData)
}
