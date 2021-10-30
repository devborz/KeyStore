//
//  SignUpViewController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 29.10.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create account"
        
        createAccountButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func keyboardChanged(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        constraint.constant = min(endFrame.minY - 10 - view.frame.height / 2, 130) - 130
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { completed in
            
        }

    }
    
    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text,
              password.count >= 8 && password == repeatPassword else {
              return
        }
        let vc = ActivityController()
        self.present(vc, animated: true, completion: nil)
        AuthManager.shared.signUp(email: email, password: password) { error in
            if error == nil {
                showHomeScreen()
            } else {
                vc.dismiss(animated: true) {
                    
                }
            }
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text else {
              createAccountButton.isEnabled = false
              return
        }
        if !email.isEmpty && password.count >= 8 &&
            repeatPassword == password {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
            
    }
}
