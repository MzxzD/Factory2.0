//
//  Coordinator.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//


import Foundation
import UIKit

public protocol Coordinator: class{
    var childCoordinator: [Coordinator] {get set}
    var presenter: UINavigationController {get set}

    func start()
}

public extension Coordinator {
    func addChildCoordinator(childCoordinator: Coordinator){
        self.childCoordinator.append(childCoordinator)
    }
    func removeChildCoordinator(childCoordinator: Coordinator){
        self.childCoordinator = self.childCoordinator.filter { $0 !== childCoordinator }
    }
}
