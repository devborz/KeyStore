//
//  AccountsListController.swift
//  GoogleAuth
//
//  Created by Усман Туркаев on 24.09.2021.
//

import UIKit

class AccountsListController: UITableViewController {
    
    var scanQRButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
    }
    
    func setupNavBar() {
        navigationItem.title = "Accounts"
        navigationController?.navigationBar.prefersLargeTitles = true
        scanQRButton = .init(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(scanQRButtonTapped))
        navigationItem.leftBarButtonItem = scanQRButton
    }
    
    func setupTableView() {
        tableView.register(AccountCell.self, forCellReuseIdentifier: "cell")
        
        AccountsManager.shared.accounts.bind { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc
    func scanQRButtonTapped() {
        let vc = QRScannerViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountsManager.shared.accounts.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountCell
        let viewModel = AccountCellViewModel(model: AccountsManager.shared.accounts.value[indexPath.row])
        cell.setup(viewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(vc, animated: true)
    }

}
