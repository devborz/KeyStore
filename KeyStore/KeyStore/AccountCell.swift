//
//  AccountCell.swift
//  KeyStore
//
//  Created by Усман Туркаев on 24.09.2021.
//

import UIKit

class AccountCell: UITableViewCell {
    
    weak var viewModel: AccountCellViewModel?
    
    let emailLabel = UILabel()
    
    let codeLabel = UILabel()
    
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emailLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(timeLabel)
        
        emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        
        codeLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5).isActive = true
        codeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        codeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: codeLabel.rightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        emailLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        codeLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        
        timeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        timeLabel.textColor = .secondaryLabel
        timeLabel.textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.seconds.removeListener()
        viewModel?.currentCode.removeListener()
        viewModel = nil
    }
    
    func setup(_ viewModel: AccountCellViewModel) {
        print(viewModel.model.secret)
        self.viewModel = viewModel
        emailLabel.text = "\(viewModel.model.issuer) - \(viewModel.model.email)"
        viewModel.currentCode.bind({ [weak self] code in
            DispatchQueue.main.async {
                self?.codeLabel.text = code?.code
            }
        })
        viewModel.seconds.bind({ [weak self] seconds in
            DispatchQueue.main.async {
                self?.timeLabel.textColor = seconds < 10 ? .systemRed : .secondaryLabel
                self?.timeLabel.text = "\(seconds)"
            }
        }, getCurrentValue: true)
    }

}
