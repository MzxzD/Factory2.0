//
//  AppCoordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    var presenter: UINavigationController
    let window: UIWindow
    let controller: NewsTableViewController
    
    init(window: UIWindow) {
        self.window = window
        controller = NewsTableViewController()
        presenter = UINavigationController()
        

    }
    

    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        presenter.pushViewController(controller, animated: true)
        
        
    }


}
