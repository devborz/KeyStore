//
//  AuthManager.swift
//  KeyStore
//
//  Created by Усман Туркаев on 30.10.2021.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthManager {
    
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static var shared = AuthManager()
    
    private init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            DBManager.shared.prepareData()
        }
    }
    
    func signIn(email: String, password: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion?(error)
        }
    }
    
    func signUp(email: String, password: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil,
                  let result = result else {
                completion?(error)
                return
            }
            DBManager.shared.createUser(id: result.user.uid, email: email) { error in
                completion?(error)
            }
        }
    }
    
    func signOut(_ completion: ((Bool) -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            completion?(true)
        } catch {
            completion?(false)
        }
    }
    
    func resetPassword(email: String, completion: ((Error?) -> Void)? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion?(error)
        }
    }
}
