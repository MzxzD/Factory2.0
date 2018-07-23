//
//  FavoriteNewsCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 12/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit

class FavoriteNewsCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    let controller: FavoriteNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let favoriteNewsontroller = FavoriteNewsViewController()
        let favoriteNewsViewModel = FavoritenewsViewModel()
        favoriteNewsontroller.favoriteListNewsViewModel = favoriteNewsViewModel
        self.controller = favoriteNewsontroller
        favoriteNewsontroller.favoriteListNewsViewModel.favoriteistNewsCoordinatorDelegate = self
    }
    
    func start() {
        presenter.present(controller, animated: true)
    }
    
}

extension FavoriteNewsCoordinator: OpenSingleNewsDelegate {
    
    func openSingleNews(selectedNews: NewsData) {
        let newsDetailCoordinator = SingleNewsCoordinator(presenter: self.presenter, news: selectedNews)
        newsDetailCoordinator.start()
        self.addChildCoordinator(childCoordinator: newsDetailCoordinator)
    }
    
    func viewControllerHasFinished() {
        self.childCoordinator.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
}

extension FavoriteNewsCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}


