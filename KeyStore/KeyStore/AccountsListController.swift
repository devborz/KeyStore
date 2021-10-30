//
//  AccountsListController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import UIKit

enum Section: Hashable, Equatable {
    case accounts
}

class AccountsListController: UITableViewController {
    
    var scanQRButton: UIBarButtonItem!
    
    var settingsButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc
    func refresh() {
        DBManager.shared.getSavedAccounts()
    }
    
    func setupNavBar() {
        navigationItem.title = "Accounts"
        
        scanQRButton = .init(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(scanQRButtonTapped))
        navigationItem.rightBarButtonItem = scanQRButton
        
        settingsButton = .init(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = settingsButton
    }
    
    func setupTableView() {
        tableView.register(AccountCell.self, forCellReuseIdentifier: "cell")
        
        DBManager.shared.accounts.bind(true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkList()
                self?.tableView.reloadData()
                guard let refreshControl = self?.refreshControl else { return }
                refreshControl.endRefreshing()
            }
        }
    }
    
    func checkList() {
        if DBManager.shared.accounts.value.isEmpty && DBManager.shared.isFirstLoadMade {
            let view = EmptyListMessage(frame: tableView.bounds)
            view.setup()
            view.layoutIfNeeded()
            tableView.backgroundView = view
        } else {
            tableView.backgroundView = nil
        }
    }
    
    @objc
    func scanQRButtonTapped() {
        let vc = QRScannerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func settingsButtonTapped() {
        let vc = SettingsViewController(style: .insetGrouped)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, compleltion in
            let alert = UIAlertController(title: "Delete this account?", message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                DBManager.shared.deleteAccount(indexPath.row)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true, completion: nil)
        }
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountCell
        cell.setup(DBManager.shared.accounts.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.shared.accounts.value.count
    }
}
