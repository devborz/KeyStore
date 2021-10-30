//
//  Functions.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import Foundation
import SwiftOTP

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

/// EXAMPLE
/// otpauth://totp/Google%3Au.turkaev%40yandex.ru?secret=tbrpy2ogve6x4jdlgls6527dtno4o4p5&issuer=Google

func parseResult(_ string: String) -> Account? {
    guard let issuerEndIndex = string.endIndex(of: "&issuer="),
          let issuerStartIndex = string.index(of: "&issuer="),
          let secretEndIndex = string.endIndex(of: "?secret="),
          let secretStartIndex = string.index(of: "?secret="),
          let emailStartIndex = string.endIndex(of: "%3A") else { return nil }
    
    var email = String(string[emailStartIndex..<secretStartIndex])
    email =  email.replacingOccurrences(of: "%40", with: "@")
    let secret = String(string[secretEndIndex..<issuerStartIndex])
    let issuer = String(string[issuerEndIndex...])
    
    let account = Account(id: UUID().uuidString, issuer: issuer, email: email, secret: secret)
    return account
}

func generateCode(for account: Account) -> Code? {
    if let data = base32DecodeToData(account.secret),
       let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1) {
        let time = Date()
        let code = Code()
        code._id = account.id
        code.code = totp.generate(time: time) ?? ""
        code.created = time
        return code
    }
    return nil
}

func resetWindow(with vc: UIViewController?) {
    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
        fatalError("could not get scene delegate ")
    }
    guard let window = sceneDelegate.window else { return }
    window.rootViewController = vc
    window.makeKeyAndVisible()
    UIView.transition(with: window,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: nil,
                        completion: nil)
}

func showLoginScreen() {
    let vc = LoginViewController()
    let navigationController = NavigationController(rootViewController: vc)
    resetWindow(with: navigationController)
}

func showHomeScreen() {
    let vc = AccountsListController()
    let navigationController = NavigationController(rootViewController: vc)
    resetWindow(with: navigationController)
}
