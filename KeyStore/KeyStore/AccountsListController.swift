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
    
    var dataSource: UITableViewDiffableDataSource<Section, AccountCellViewModel>!
    
    var isFirstLoadMade = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    func setupNavBar() {
        navigationItem.title = "Accounts"
        
        scanQRButton = .init(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(scanQRButtonTapped))
        navigationItem.rightBarButtonItem = scanQRButton
    }
    
    func setupTableView() {
        tableView.register(AccountCell.self, forCellReuseIdentifier: "cell")
        
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountCell
            cell.setup(viewModel)
            return cell
        })
        update()
        dataSource.defaultRowAnimation = .top
        
        AccountsManager.shared.accounts.bind { [weak self] _ in
            guard let isFirstLoadMade = self?.isFirstLoadMade else { return }
            DispatchQueue.main.async {
                if isFirstLoadMade {
                    self?.update()
                } else {
                    self?.reload()
                    self?.isFirstLoadMade = true
                }
            }
        }
    }
    
    func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AccountCellViewModel>()
        snapshot.appendSections([.accounts])
        snapshot.appendItems(AccountsManager.shared.accounts.value, toSection: .accounts)
        dataSource.apply(snapshot, animatingDifferences: false)
        checkList()
    }
    
    func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AccountCellViewModel>()
        snapshot.appendSections([.accounts])
        snapshot.appendItems(AccountsManager.shared.accounts.value, toSection: .accounts)
        dataSource.apply(snapshot)
        checkList()
    }
    
    func checkList() {
        if AccountsManager.shared.accounts.value.isEmpty {
            let view = EmptyListMessage(frame: tableView.bounds)
            view.setup()
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, compleltion in
            let alert = UIAlertController(title: "Delete this account?", message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                AccountsManager.shared.deleteAccount(indexPath.row)
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
}
