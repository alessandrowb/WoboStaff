//
//  AppDelegate.swift
//  WoboStaff
//
//  Created by Alessandro on 12/31/15.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

// MARK: - Public structs

struct AppColors
{
    static let generalSystemColor = UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1.0) /* #007aff */
}

// MARK: - UIApplication functions

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let navigationBarAppearance = UINavigationBar.appearance()
        let uiBarButtonItemAppearance = UIBarButtonItem.appearance()
        let fontAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName:UIColor.orangeColor()]
        
        navigationBarAppearance.translucent = false
        navigationBarAppearance.tintColor = UIColor.orangeColor()
        navigationBarAppearance.barTintColor = AppColors.generalSystemColor
        navigationBarAppearance.titleTextAttributes = fontAttributes
        uiBarButtonItemAppearance.setTitleTextAttributes(fontAttributes, forState: .Normal)
        
        return true
    }

}