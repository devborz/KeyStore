//
//  AccountsManager.swift
//  GoogleAuth
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation

class AccountsManager {
    
    static var shared = AccountsManager()
    
    var accounts = DefinedObservable<[Account]>([])
    
    private init() {
        fetchSavedAccounts()
    }
    
    private func fetchSavedAccounts() {
        for _ in 0...4 {
            accounts.value.append(Account(email: "test@gmail.com"))
        }
    }
    
    func saveAccount(_ account: Account) {
        
    }
}
