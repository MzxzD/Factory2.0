//
//  NewsCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 10/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class SingleNewsCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    private let singleNewsController: SingleNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    let favoriteButtonAppearence = UIBarButtonItem.appearance()
    
    init(presenter: UINavigationController, news: NewsData) {
        self.presenter = presenter
        let singleNewsController = SingleNewsViewController()
        let singleNewsViewModel = SingleNewsViewModel()
        singleNewsController.singleNewsViewModel = singleNewsViewModel
        self.singleNewsController = singleNewsController
        singleNewsViewModel.newsData = news
    }
    
    func start() {
        presenter.pushViewController(singleNewsController, animated: true)
    }
    
    @objc func favButtonTapped(){
    }
    
    deinit {
    }
}

extension SingleNewsCoordinator: OpenSingleNewsDelegate{
    func openSingleNews(selectedNews: NewsData) {
        
    }
    
    func viewControllerHasFinished() {
        childCoordinator.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
}

extension SingleNewsCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}


