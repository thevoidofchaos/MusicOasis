//
//  ConversationCell.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 26/05/23.
//

import Foundation
import UIKit

class ConversationCell: UITableViewCell {
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.systemGray

        return label
    }()
    
    let lastestMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.systemGray2

        return label
    }()
    
    let userImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "conversationCell")
        
        contentView.addSubview(userImageView)
        contentView.addSubview(emailLabel)
        contentView.addSubview(lastestMessageLabel)
        
        NSLayoutConstraint.activate([
                                     
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            
            lastestMessageLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 1),
            lastestMessageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 5),
            lastestMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lastestMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
            
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
