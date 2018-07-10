//
//  NewsListCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit



class NewsTableCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    let controller: NewsTableViewController
 
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let newsController = NewsTableViewController()
        let tableViewModel = NewsTableViewModel(newsService: NewsDataService())
        newsController.newTableVieMode = tableViewModel
        self.controller = newsController
 
    }
    
    deinit {
        print("deinit")
    }
    
    func start() {
        print("Coordinator is beaing used")
        controller.newTableVieMode.newsTableDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
    
}
extension NewsTableCoordinator: NewsTableCoordinatorDelegate {
    
    
    
    func openDetailNews(selectedNews: NewsData) {
        let newsDetailCoordinator = NewsCoordinator(presenter: self.presenter, news: selectedNews)
        newsDetailCoordinator.start()
        self.addChildCoordinator(childCoordinator: newsDetailCoordinator)
        print(self.childCoordinator)
        
    }
    
    func viewControllerHasFinished() {
        
    }
    
    
    
    
}

