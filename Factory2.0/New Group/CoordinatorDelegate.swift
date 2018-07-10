//
//  CoordinatorDelegate.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 09/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation

protocol CoordinatorDelegate: class {
    func viewControllerHasFinished()
}

protocol ParentCoordinatorDelegate: class {
    func childHasFinished(coordinator: Coordinator)
}

