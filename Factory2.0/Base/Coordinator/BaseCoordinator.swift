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
//        let listNewsViewModel = ListNewsViewModel(newsService: APIRepository())
//        baseViewController.listNewsViewModel = listNewsViewModel
        
        let listNewsViewCoordinator = ListNewsCoordinator(presenter: presenter)
        self.controller = baseViewController
        self.controller.setViewControllers([listNewsViewCoordinator.controller], animated: false)
        listNewsViewCoordinator.start()
        
    }
    
    func start() {
        print("Coordinator is beaing used")
     //   controller.listNewsViewModel.listNewsCoordinatorDelegate = self
//        let coordinator = ListNewsCoordinator(presenter: self.presenter)
//        coordinator.start()
//        self.addChildCoordinator(childCoordinator: coordinator)
//        print(self.childCoordinator)
        presenter.pushViewController(controller, animated: true)
    }
    
    deinit {
        print("LstNewsCoorinatorDeinitialised!")
    }
    
    
    
}

//extension BaseCoordinator: BaseCoordinatorDelegate{
//   // func initData(viewModel: ) {
//        let viewModel = ListNewsViewModel(newsService: APIRepository())
//    }
//    
//    
//}

//extension BaseCoordinator: ListNewsCoordinatorDelegate {
//    
//    
//    
//    func openSingleNews(selectedNews: NewsData) {
//        let newsDetailCoordinator = SingleNewsCoordinator(presenter: self.presenter, news: selectedNews)
//        newsDetailCoordinator.start()
//        self.addChildCoordinator(childCoordinator: newsDetailCoordinator)
//        print(self.childCoordinator)
//        
//    }
//    
//    func viewControllerHasFinished() {
//        self.childCoordinator.removeAll()
//        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
//        //   self.removeChildCoordinator(childCoordinator: self)
//    }
//    
//}
//
//extension BaseCoordinator: ParentCoordinatorDelegate{
//    func childHasFinished(coordinator: Coordinator) {
//        removeChildCoordinator(childCoordinator: coordinator)
//    }
//    
//}

