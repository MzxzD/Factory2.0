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
//        let favoriteNewsViewModel =
        self.controller = favoriteNewsontroller
    }
    
    
    func start() {
        
    }
    
    
}

extension FavoriteNewsCoordinator: ParentCoordinatorDelegate{
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}
