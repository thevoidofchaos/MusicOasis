//
//  CustomTabBar.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 13/05/23.
//

//import UIKit
//
//class CustomTabBar: UITabBar {
//
//    private var shapeLayer: CALayer?
//
//    private func addShape() {
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = createPath()
//        shapeLayer.fillColor = UIColor.white.cgColor
//
//        shapeLayer.shadowColor = UIColor.black.cgColor
//        shapeLayer.shadowOpacity = 0.3
//        shapeLayer.shadowRadius = 10
//        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
//
//        let shadow = UIBezierPath(roundedRect: CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
//
//        shapeLayer.shadowPath = shadow.cgPath
//
//        ///Note the difference in the methods. There are 2 methods 'replaceSublayer' and 'insertSublayer'. There is also another method 'addSublayer'.
//
//        ///The insertSublayer inserts the sublayer at the specified index in the layer's list of sublayers. 0 means that the sublayer will be added to the back of the sublayers.
//        ///The 'addSublayer' appends the sublayer to the layer's list of sublayers.
//        ///The 'replaceSublayer' replaces the sublayer with another sublayer.
//
//        ///If only self.layer.insertSublayer(shapeLayer, at: 0) is called, a new layer will be inserted at index 0 every time the draw function is called BUT the old shapeLayer will still be present. So, replaceSublayer is used.
//
//        ///TEST:  print(self.layer.sublayers?.count) prints optional(4) and then optional(5) and optional(6) and optional(7) and optional(8) and so on when only insertSublayer is used meaning that the old subLayer is still present in memory.
//
//
//        if let oldShapeLayer = self.shapeLayer {
////            print("oldShapeLayer is present.")
//            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
//        } else {
////            print("oldShapeLayer is absent.")
//            self.layer.insertSublayer(shapeLayer, at: 0)
//        }
//
//        self.shapeLayer = shapeLayer
//
//    }
//
//    override func draw(_ rect: CGRect) {
//        self.addShape()
//        self.unselectedItemTintColor = UIColor.gray
//        self.tintColor = UIColor(named: "accentColor")
//
//    }
//
//
//    private func createPath() -> CGPath {
//
//        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
//
//
//        return path.cgPath
//    }
//
//}
