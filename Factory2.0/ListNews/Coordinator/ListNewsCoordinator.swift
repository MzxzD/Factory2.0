//
//  NewsListCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit



class ListNewsCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ListNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let listNewsController = ListNewsViewController()
        let listNewsViewModel = ListNewsViewModel(newsService: APIRepository())
        listNewsController.listNewsViewModel = listNewsViewModel
        self.controller = listNewsController
 
    }
    
    func start() {
        print("Coordinator is beaing used")
        controller.listNewsViewModel.listNewsCoordinatorDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("LstNewsCoorinatorDeinitialised!")
    }
    
    
    
}
extension ListNewsCoordinator: ListNewsCoordinatorDelegate {
    
    
    
    func openSingleNews(selectedNews: NewsData) {
        let newsDetailCoordinator = SingleNewsCoordinator(presenter: self.presenter, news: selectedNews)
        newsDetailCoordinator.start()
        self.addChildCoordinator(childCoordinator: newsDetailCoordinator)
        print(self.childCoordinator)
        
    }
    
    func viewControllerHasFinished() {
        self.childCoordinator.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
     //   self.removeChildCoordinator(childCoordinator: self)
    }
    
}

extension ListNewsCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }

}

