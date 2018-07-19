//
//  CustomNavigationController.swift
//  filedownloader
//
//  Created by Daniel Hjärtström on 2018-07-19.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol NavigationBarStyleProtocol { }
extension NavigationBarStyleProtocol where Self : UINavigationController {
    func layoutNavigationBarUsing(backgroundColor: UIColor, largeTitle: Bool, smallTitleColor: UIColor, largeTitleColor: UIColor = UIColor.black) {
        navigationBar.barTintColor = backgroundColor
        navigationBar.prefersLargeTitles = largeTitle
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:smallTitleColor]
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:largeTitleColor]
    }
}

class CustomNavigationController: UINavigationController, NavigationBarStyleProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNavigationBarUsing(backgroundColor: UIColor.orange,
                                 largeTitle: true,
                                 smallTitleColor: UIColor.white,
                                 largeTitleColor: UIColor.white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
