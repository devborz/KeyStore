//
//  ActivityController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 29.10.2021.
//

import UIKit

class ActivityController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        
        view.backgroundColor = .init(white: 0, alpha:   0.3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
    }

}
