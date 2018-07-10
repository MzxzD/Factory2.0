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
    let controller: NewsTableViewController
    var presenter: UINavigationController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let controller = NewsTableViewController()
        var viewModel = NewsTableViewModel(newsService: NewsDataService())
        controller.newTableVieMode = viewModel
        self.controller = controller
    }
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}

extension NewsTableCoordinator: NewsTableCoordinatorDelegate {
    func openDetailNews(selectedNews: NewsData) {
        let coordinator = NewsCoordinator(presenter: presenter)
        coordinator.parentCoordinatorDelegate = self
        addChildCoordinator(childCoordinator: coordinator)
        coordinator.start()
    }
    
    func viewControllerHasFinished() {
        childCoordinator.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
    
}

extension NewsTableCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}
