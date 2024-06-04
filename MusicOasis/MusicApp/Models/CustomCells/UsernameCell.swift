//
//  UsernameCell.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 08/06/23.
//

import Foundation
import UIKit

class UsernameCell: UITableViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1  
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.black
        
        return label
   }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "usernameCell")
        
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
        
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
