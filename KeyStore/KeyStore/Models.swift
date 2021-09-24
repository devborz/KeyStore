//
//  Models.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import CryptoKit
import RealmSwift

class Account: Object {
    @Persisted var id: String = ""
    
    @Persisted var issuer: String = ""
    
    @Persisted var email: String = ""
    
    @Persisted var secret: String = ""
}

class Code: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var code: String = ""
    @Persisted var created: Date = Date()
}
