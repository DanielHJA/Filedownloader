//
//  CustomTabBarController.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-21.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private lazy var downloadController: UIViewController = {
        let temp = ViewController()
        temp.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        return temp
    }()
    
    private lazy var filesController: UIViewController = {
        let temp = FilesViewController()
        temp.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        return temp
    }()
    
    override func loadView() {
        super.loadView()
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.orange
        let tabs = [downloadController, filesController]
        viewControllers = tabs.map { CustomNavigationController(rootViewController: $0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
