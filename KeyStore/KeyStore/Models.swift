//
//  Models.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import CryptoKit

struct Account {
    var id: String = ""
    
    var issuer: String = ""
    
    var email: String = ""
    
    var secret: String = ""
    
    var dict: [String: Any] {
        return [
            "id": id,
            "issuer": issuer,
            "email": email,
            "secret": secret
        ]
    }
}

extension Account {
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
              let issuer = dict["issuer"] as? String,
              let email = dict["email"] as? String,
              let secret = dict["secret"] as? String else { return nil }
        self.init(id: id, issuer: issuer, email: email, secret: secret)
    }
}

struct Code {
    var secret: String
    var code: String
    var timeInterval: Date
}

struct DBUser {
    let id: String
    let email: String
    
    var dict: [String: Any] {
        return [
            "id": id,
            "email": email
        ]
    }
}

extension DBUser {
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
              let email = dict["email"] as? String else { return nil }
        self.init(id: id, email: email)
    }
}
