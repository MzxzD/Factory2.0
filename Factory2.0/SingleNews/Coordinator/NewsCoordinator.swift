//
//  NewsCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 10/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class NewsCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    private let controller: NewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController, news: NewsData) {
        self.presenter = presenter
        let newsController = NewsViewController()
        let viewModel = NewsViewModel()
        newsController.modelView = viewModel
        self.controller = newsController
        viewModel.newsData = news
    }
    
    
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
}


extension NewsCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}


