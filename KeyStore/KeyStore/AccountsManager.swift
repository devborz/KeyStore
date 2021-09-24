//
//  AccountsManager.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import RealmSwift

class AccountsManager {
    
    static var shared = AccountsManager()
    
    var accounts = DefinedObservable<[AccountCellViewModel]>([])
    
    private init() {
        DispatchQueue.main.async { [weak self] in
            self?.fetchSavedAccounts()
        }
    }
    
    private func fetchSavedAccounts() {
        if let realm = try? Realm() {
            let list = realm.objects(Account.self)
            accounts.value = Array(list).map { AccountCellViewModel(model: $0) }
        }
    }
    
    func fetchLastCodeForAccount(_ account: Account) -> Code? {
        if let realm = try? Realm() {
            return realm.object(ofType: Code.self, forPrimaryKey: account.id)
        } else {
            return nil
        }
    }
    
    func saveAccount(_ account: Account) {
        accounts.value.append(.init(model: account))
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(account)
            }
        }
    }
    
    func deleteAccount(_ index: Int) {
        let account = accounts.value[index].model
        accounts.value.remove(at: index)
        if let realm = try? Realm() {
            try? realm.write {
                realm.delete(account)
            }
        }
    }
    
    func saveCode(_ code: Code, for account: Account) {
        if let realm = try? Realm() {
            try? realm.write {
                if let lastCode = realm.object(ofType: Code.self, forPrimaryKey: account.id) {
                    realm.delete(lastCode)
                }
                realm.add(code)
            }
        }
    }
}
