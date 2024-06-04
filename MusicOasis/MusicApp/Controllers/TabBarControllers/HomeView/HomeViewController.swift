//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 11/05/23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    //TODO: -
    
    //Add settings view controller with user profile view controller.
    //Add 'Discover me' view controller; Map.
    //Design the UI of 'Discover me' view controller.
    
    override func viewDidLoad() {
        tabBarController?.view.tintColor = UIColor.celadonGreen
        tabBarController?.tabBar.backgroundColor = UIColor.white
        tabBarController?.tabBar.isTranslucent = true
        
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4743164778, green: 0.6439556479, blue: 0.9490683675, alpha: 1)
        
        
    }
    
    @objc func settingsPressed() {
        print(#function)
        
        performSegue(withIdentifier: "homeToSettings", sender: self)
        
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToSettings", sender: self)
    }
    
}
