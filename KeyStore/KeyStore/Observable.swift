//
//  Observable.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation

class DefinedObservable<T> {
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    var listener: ((T) -> Void)?
    
    func bind(_ getCurrentValue: Bool = false, listener: @escaping (T) -> Void) {
        self.listener = listener
        if getCurrentValue {
            listener(value)
        }
    }
    
    func removeListener() {
        listener = nil
    }
    
    init(_ value: T) {
        self.value = value
    }
}

class Observable<T> {
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
        listener(value)
    }
    
    func removeListener() {
        listener = nil
    }
}
