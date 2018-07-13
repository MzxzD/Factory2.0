//
//  BaseViewController.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 11/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class BaseViewController: UITabBarController {

   var listNewsViewModel: ListNewsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor.white
        navigationItem.title = "Factory"
    }

}

