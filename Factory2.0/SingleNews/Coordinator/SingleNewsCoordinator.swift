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
    var favoriteButton : UIButton = {
        var button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "star_black"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "favorite"), for: .selected )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
//    let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
    
    var presenter: UINavigationController
    private let singleNewsController: SingleNewsViewController
    weak var parentCoordinatorDelegate: ParentCoordinatorDelegate?
    
    init(presenter: UINavigationController, news: NewsData) {
        self.presenter = presenter
       
        let singleNewsController = SingleNewsViewController()
        let singleNewsViewModel = SingleNewsViewModel()
        singleNewsController.singleNewsViewModel = singleNewsViewModel
        self.singleNewsController = singleNewsController
        singleNewsViewModel.newsData = news
    }
    
    
    func start() {
        print("StartToSingleNews")
        presenter.pushViewController(singleNewsController, animated: true)
    }
    
   @objc func favButtonTapped(){
        print("Tapped!")
    }
    
    deinit {
        print("SingleNewsCoorinatorDeinitialised!")
    }
}

extension SingleNewsCoordinator: ListNewsCoordinatorDelegate{
    func openSingleNews(selectedNews: NewsData) {
        
    }
    
    func viewControllerHasFinished() {
        print("ViewControllerHasFinished")
        childCoordinator.removeAll()
        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
    
}


extension SingleNewsCoordinator: ParentCoordinatorDelegate {
    func childHasFinished(coordinator: Coordinator) {
        removeChildCoordinator(childCoordinator: coordinator)
    }
}


