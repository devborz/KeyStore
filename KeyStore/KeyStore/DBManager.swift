//
//  AccountsManager.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import RealmSwift
import FirebaseFirestore

class DBManager {
    
    static var shared = DBManager()
    
    var accounts = DefinedObservable<[AccountCellViewModel]>([])
    
    private var db = Firestore.firestore()
    
    var isFirstLoadMade = false
    
    private init() {
    }
    
    func prepareData() {
        clear()
        getSavedAccounts()
    }
    
    func clear() {
        isFirstLoadMade = false
        accounts.value = []
    }
    
    func createUser(id: String, email: String, completion: ((Error?) -> Void)?) {
        db.collection("users").document(id).setData(["id": id, "email": email]) { error in
            completion?(error)
        }
    }
    
    func getSavedAccounts() {
        guard let uid = AuthManager.shared.currentUserID else { return }
        db.collection("users").document(uid).collection("accounts").getDocuments { snapshot, error in
            guard error == nil,
                  let docs = snapshot?.documents else {
                      print(error?.localizedDescription)
                      return
                  }
            var accounts: [Account] = []
            for doc in docs {
                if let account = Account(dict: doc.data()) {
                    accounts.append(account)
                }
            }
            self.isFirstLoadMade = true
            self.accounts.value = accounts.map { AccountCellViewModel(model: $0) }
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
        guard let uid = AuthManager.shared.currentUserID else { return }
        db.collection("users").document(uid).collection("accounts").document(account.id).setData(account.dict)
    }
    
    func deleteAccount(_ index: Int) {
        let account = accounts.value[index].model
        accounts.value.remove(at: index)
        guard let uid = AuthManager.shared.currentUserID else { return }
        db.collection("users").document(uid).collection("accounts").document(account.id).delete()
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
