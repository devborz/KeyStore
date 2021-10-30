//
//  NavigationController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
//        view.backgroundColor = .systemBackground
        
        navigationBar.tintColor = .red
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            
            return topVC.preferredStatusBarStyle
        }

        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
    }
}
