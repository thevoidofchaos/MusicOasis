//
//  CustomTabBarController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 13/05/23.
//

//import Foundation
//import UIKit
//import LNPopupController
//
//class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.delegate = self
//
//        if #available(iOS 13.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.backgroundColor = UIColor.white
//            appearance.stackedLayoutAppearance.normal.iconColor = .white
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
//            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.celadonGreen
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.celadonGreen]
//            appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = .red
//            appearance.stackedLayoutAppearance.normal.badgeTextAttributes = [.foregroundColor: UIColor.black]
//            tabBar.isTranslucent = true
//            tabBar.standardAppearance = appearance
//            
//        }
//        
//        //MARK: - Initializing the navigation controllers
//        let homeViewController = HomeViewController()
//        homeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: homeViewController, action: #selector(homeViewController.settingsPressed))
//        
//        let homeNavController = UINavigationController(rootViewController: homeViewController)
//        let searchNavController = UINavigationController(rootViewController: SearchViewController())
//        let conversationNavController = UINavigationController(rootViewController: ConversationViewController())
//        
//        
//        
//        //MARK: - Tab bar buttons for navigation controllers
//        
//        let homeBtn = UITabBarItem(title: "home", image: UIImage(systemName: "music.note.house"), selectedImage: UIImage(systemName: "music.note.house"))
//        let searchBtn = UITabBarItem(title: "search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle"))
//        let chatBtn = UITabBarItem(title: "chat", image: UIImage(systemName: "text.bubble"), selectedImage: UIImage(systemName: "text.bubble"))
//       
//        homeNavController.tabBarItem = homeBtn
//        searchNavController.tabBarItem = searchBtn
//        conversationNavController.tabBarItem = chatBtn
//        
//        
//        self.viewControllers = [homeNavController, searchNavController, conversationNavController]
//
//        let demoVC = UIViewController()
//        demoVC.view.backgroundColor = UIColor.amethyst
//        demoVC.popupItem.title = "Title"
//        demoVC.popupItem.subtitle = "Subtitle"
//         
//        self.presentPopupBar(withContentViewController: demoVC, animated: true)
//        
//    }
    
    
    //NOT USING CUSTOM TAB BAR ANYMORE.
    
//    ///Note from documentation on LNPopUpController: The returned view must be attached to the bottom of the view controller's view, or results are undefined.
//
//    ///The dock view is the view above which the popup bar will appear. This will return the custom tab bar.
//    override var bottomDockingViewForPopupBar: UIView? {
//        return self.tabBar
//    }
//
//    override var defaultFrameForBottomDockingView: CGRect {
//
//        ///Making a copy of the frame of the dock view. The popup bar will use this copy of the tab bar frame to set its position based on the visibility of the custom tab bar.
//        ///The dock view is the custom tab bar is this case.
//        var bottomViewFrame = self.tabBar.frame
//
//        ///When the tab bar is hidden, the popup bar will change its position (not become hidden itself unless explicit set which is what I want). It will move down.
//        ///The popup bar will use this frame as the dock view frame to set its position accordingly.
//        if self.tabBar.isHidden == true {
//            bottomViewFrame.origin = CGPoint(x: 0, y: view.frame.height)
//        }
//
//        ///When the tab bar is visible, the popup bar will change its position to move up.
//        else {
//            bottomViewFrame.origin = CGPoint(x: 0, y: view.frame.height - (view.frame.height * 0.12))
//        }
//
//        return bottomViewFrame
//    }


    
//}
