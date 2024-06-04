//
//  SongsTableViewCell.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 01/05/23.
//

import Foundation
import UIKit
import SkeletonView


//FIXME: - Change 'Song' to generic 'MusicItem'


class SongsTableViewCell: UITableViewCell {
    
    let songBackgroundView: UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white

        return view
    }()
    
    let artworkImageView:  UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let songInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let songTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.black
        
        return label
    }()
    
     let songArtist: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.gray

        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "songCell")
        
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.addSubview(songBackgroundView)
        songBackgroundView.addSubview(artworkImageView)
        songBackgroundView.addSubview(songInfoView)
        songInfoView.addSubview(songTitle)
        songInfoView.addSubview(songArtist)
        
        
        NSLayoutConstraint.activate([
        
            songBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            songBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            songBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            artworkImageView.centerYAnchor.constraint(equalTo: songBackgroundView.centerYAnchor),
            artworkImageView.leadingAnchor.constraint(equalTo: songBackgroundView.leadingAnchor, constant: 10),
            artworkImageView.widthAnchor.constraint(equalToConstant: 70),
            artworkImageView.heightAnchor.constraint(equalToConstant: 70),
            
            songInfoView.centerYAnchor.constraint(equalTo: songBackgroundView.centerYAnchor),
            songInfoView.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 2),
            songInfoView.trailingAnchor.constraint(equalTo: songBackgroundView.trailingAnchor, constant: -2),
            songInfoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -5),
            
            songTitle.topAnchor.constraint(equalTo: songInfoView.topAnchor, constant: 10),
            songTitle.leadingAnchor.constraint(equalTo: songInfoView.leadingAnchor, constant: 10),
            songTitle.trailingAnchor.constraint(equalTo: songInfoView.trailingAnchor, constant: -10),
            
            songArtist.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 5),
            songArtist.leadingAnchor.constraint(equalTo: songInfoView.leadingAnchor, constant: 10),
            songArtist.trailingAnchor.constraint(equalTo: songInfoView.trailingAnchor, constant: -10),
        
        ])
        
        songBackgroundView.isSkeletonable = true
        artworkImageView.isSkeletonable = true
        songInfoView.isSkeletonable = true
        songTitle.isSkeletonable = true
        songArtist.isSkeletonable = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
