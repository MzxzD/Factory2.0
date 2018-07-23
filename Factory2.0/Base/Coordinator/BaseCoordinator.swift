//
//  BaseCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 11/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit



class BaseCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    let controller: BaseViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        let baseViewController = BaseViewController()
        self.controller = baseViewController
        
        let favoriteNewsCoordinator = FavoriteNewsCoordinator(presenter: presenter)
        let favouriteNewsNavigationController = createNavigationController(viewController: favoriteNewsCoordinator.controller, name: "FAVOURITE LIST", unselectedImage: "star_black", selectedImage: "star_white")
     //   presenter.navigationItem.title = favouriteNewsNavigationController.tabBarItem.title
        
        let listNewsCoordinator = ListNewsCoordinator(presenter: presenter)
        let listNewsNavigationController = createNavigationController(viewController: listNewsCoordinator.controller, name: "LIST NEWS", unselectedImage: "list_news", selectedImage: "list_news")
        
        self.controller.setViewControllers([listNewsNavigationController, favouriteNewsNavigationController], animated: false)
        listNewsCoordinator.controller.listNewsViewModel.listNewsCoordinatorDelegate = listNewsCoordinator
    }
    
    func start() {
        print("Coordinator is beaing used")
        presenter.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("LstNewsCoorinatorDeinitialised!")
    }
    
    func createNavigationController(viewController: UIViewController ,name: String, unselectedImage: String, selectedImage: String ) -> UINavigationController{
        let newNavigationController = UINavigationController(rootViewController: viewController)
        newNavigationController.tabBarItem.title = name
        newNavigationController.tabBarItem.image = UIImage(named: unselectedImage)
        newNavigationController.tabBarItem.selectedImage =  UIImage(named: selectedImage )
        newNavigationController.navigationItem.title = name
        return newNavigationController
    }
    
}





