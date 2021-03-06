//
//  AccountCellViewModel.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import SwiftOTP

class AccountCellViewModel: Hashable, Equatable {
    static func == (lhs: AccountCellViewModel, rhs: AccountCellViewModel) -> Bool {
        return lhs.model.id == rhs.model.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }
    
    var model: Account
    
    var currentCode: Observable<Code> = Observable()
    
    var seconds: DefinedObservable<Int> = DefinedObservable(0)
    
    var timer: Timer?
    
    init(model: Account) {
        self.model = model
        generateNewCode()
    }
    
    func generateNewCode() {
        if let code = generateCode(for: model) {
            currentCode.value = code
            let components = Calendar.current.dateComponents([.second], from: code.timeInterval, to: Date())
            seconds.value = 30 - (components.second ?? 0)
            setupTimer()
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self,
                  let code = strongSelf.currentCode.value else { return }
            let components = Calendar.current.dateComponents([.second], from: code.timeInterval, to: Date())
            strongSelf.seconds.value = 30 - (components.second ?? 0)
            if strongSelf.seconds.value <= 0 {
                timer.invalidate()
                strongSelf.generateNewCode()
            }
        })
    }
    
    @objc
    func handleTime() {
        guard let code = currentCode.value else { return }
        let components = Calendar.current.dateComponents([.second], from: code.timeInterval, to: Date())
        seconds.value = 30 - (components.second ?? 0)
        if seconds.value <= 0 {
            timer?.invalidate()
            generateNewCode()
        }
    }
}
