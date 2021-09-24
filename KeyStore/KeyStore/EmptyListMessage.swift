//
//  EmptyListMessage.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import UIKit

class EmptyListMessage: UIView {

    let imageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let messageLabel = UILabel()
    
    let containerView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.font  = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textAlignment = .center
        
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        imageView.image = UIImage(systemName: "person.crop.circle")
        titleLabel.text = NSLocalizedString("Accounts", comment: "")
        messageLabel.text = NSLocalizedString("You will see linked accounts and TOTP-codes here", comment: "")
    }
}
