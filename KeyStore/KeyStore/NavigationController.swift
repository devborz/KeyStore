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
        view.backgroundColor = .systemBackground
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.setBackgroundImage(UIImage(), for: .defaultPrompt)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .red
        navigationBar.barTintColor = .systemBackground
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
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
