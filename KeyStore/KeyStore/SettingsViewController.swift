//
//  SettingsViewController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 30.10.2021.
//

import UIKit

class SettingsViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.attributedText = .init(string: "Sign Out", attributes: [.foregroundColor : UIColor.red])
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == .init(row: 0, section: 0) {
            AuthManager.shared.signOut { success in
                if success {
                    showLoginScreen()
                }
            }
        }
    }
}
