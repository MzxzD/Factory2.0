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
    var presenter = UINavigationController()
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
       
    
    }
    

    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        let coordinator = BaseCoordinator(presenter: self.presenter)
        coordinator.start()
        self.addChildCoordinator(childCoordinator: coordinator)
        print(self.childCoordinator)
                
        
    }

}



