//
//  DiscoverMeViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 24/05/23.
//

import Foundation
import UIKit
import MapKit

class DiscoverMeViewController: UIViewController, MKMapViewDelegate {
    
    static var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(MKMapView(frame: view.frame))
        
        
        
    }
}
