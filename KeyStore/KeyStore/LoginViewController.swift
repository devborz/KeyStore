//
//  LoginViewController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 29.10.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldsView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sign in"
        signInButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        constraint.constant = min(endFrame.minY - 10 - view.frame.height / 2, 110) - 110
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { completed in
            
        }

    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
              return
        }
        let vc = ActivityController()
        self.present(vc, animated: true, completion: nil)
        AuthManager.shared.signIn(email: email, password: password) { error in
            if error == nil {
                showHomeScreen()
            } else {
                vc.dismiss(animated: true) {
                    
                }
            }
        }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        let vc = ForgotPasswordController()
        vc.delegate = self
        let navController = NavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .coverVertical
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
              signInButton.isEnabled = false
              return
        }
        if !email.isEmpty && password.count >= 8 {
                signInButton.isEnabled = true
        } else {
            signInButton.isEnabled = false
        }
            
    }
}

extension LoginViewController: ForgotPasswordControllerDelegate {
    func didSendPasswordReset(to email: String) {
        let alertController = UIAlertController(title: "Success", message: "Follow instructions sent to \(email)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
