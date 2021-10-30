//
//  ForgotPasswordController.swift
//  KeyStore
//
//  Created by Усман Туркаев on 29.10.2021.
//

import UIKit

protocol ForgotPasswordControllerDelegate: AnyObject {
    
    func didSendPasswordReset(to email: String)
}

class ForgotPasswordController: UIViewController {
    
    weak var delegate: ForgotPasswordControllerDelegate?

    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Forgot password"
        resetPasswordButton.isEnabled = false
        
        emailTextField.delegate = self
        
        closeButton = .init(image: "xmark".image, style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = closeButton
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
        constraint.constant = min(endFrame.minY - 10 - view.frame.height / 2, 90) - 90
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { completed in
            
        }

    }

    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        let vc = ActivityController()
        self.present(vc, animated: true, completion: nil)
        AuthManager.shared.resetPassword(email: email) { [weak self] error in
            vc.dismiss(animated: true) {
                guard error == nil else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        alertController.dismiss(animated: true) {
                            
                        }
                    }
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                    return
                }
                var delegate = self?.delegate
                self?.navigationController?.dismiss(animated: true) {
                    delegate?.didSendPasswordReset(to: email)
                }
            }
        }
    }
    
    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc
    func closeButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension ForgotPasswordController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let email = emailTextField.text else {
              resetPasswordButton.isEnabled = false
              return
        }
        resetPasswordButton.isEnabled = !email.isEmpty
        
    }
}
