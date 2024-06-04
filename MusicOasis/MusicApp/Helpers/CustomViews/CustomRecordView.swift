//
//  CustomRecordView.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 10/05/23.
//

import Foundation
import UIKit
import CoreImage

class CustomRecordView: UIImageView {
    
//    var recordImage: UIImage = UIImage(named: "weeknd")!
    var imageUrl: URL?
    
    private lazy var holeLayer: CAShapeLayer = {
        
        let l = CAShapeLayer()
        l.strokeColor = UIColor.outerHole.cgColor
        l.fillColor = UIColor.innerHole.cgColor
        l.lineWidth = 8
        layer.addSublayer(l)
        
        return l
    }()
    
    
    var bezierPath: UIBezierPath {
        let rect = CGRect(x: bounds.midX - 10, y: bounds.midY - 10, width: 20, height: 20)
        let path = UIBezierPath(ovalIn: rect)
        
        return path
    }
    
    private lazy var patternLayer: CAShapeLayer = {
        
        let l = CAShapeLayer()
        l.strokeColor = UIColor.outerHole.cgColor
        l.fillColor = UIColor.innerHole.cgColor
        layer.addSublayer(l)
        
        return l
    }()
    
    let patternPath = UIBezierPath()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.width/2
        self.contentMode = .scaleAspectFit
        self.layer.borderWidth = 14
        self.layer.borderColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1).cgColor
        self.clipsToBounds = true
        
        
        holeLayer.frame = bounds
        holeLayer.path = bezierPath.cgPath
      
        
        //MARK: - PATTERN
        
        patternLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width - 28, height: self.bounds.height - 28)


        // Add concentric circles to the pattern
        for i in 0...47 {
            let circlePath = UIBezierPath(ovalIn: CGRect(x: i * 3, y: i * 3, width: Int(self.bounds.width) - (i * 6), height: Int(self.bounds.height) - (i * 6)))

            patternPath.append(circlePath)
        }

        patternLayer.strokeColor = UIColor.white.cgColor
        patternLayer.opacity = 0.1
        patternLayer.lineWidth = 1
        patternLayer.path = patternPath.cgPath
        
        
    }
   
}
