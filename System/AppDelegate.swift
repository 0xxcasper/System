//
//  AppDelegate.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red:0.45, green:0.44, blue:0.87, alpha:1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = HomeViewController()
        vc.title = "System Utilities"
        let nc = CustomNavigation(rootViewController: vc)

        window?.backgroundColor = .white
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }
}

class CustomNavigation: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}



