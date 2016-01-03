//
//  HipChatConfigFile.swift
//  WoboStaff
//
//  Created by Alessandro on 1/3/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import Foundation

class HipChatConfigFile {
    
    class var sharedInstance: HipChatConfigFile {
        
        struct Singleton
        {
            static let instance = HipChatConfigFile()
        }
        return Singleton.instance
        
    }
    
    private var configValues: NSDictionary!
    
    required init()
    {
        let filePath = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        self.configValues = NSDictionary(contentsOfFile:filePath)
    }
    
    var hipChatToken: String
    {
        get {
            return configValues["HipChatToken"] as! String
        }
    }
    
}