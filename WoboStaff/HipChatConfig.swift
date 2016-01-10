//
//  HipChatConfig.swift
//  WoboStaff
//
//  Created by Alessandro on 1/9/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import Foundation

// MARK: - Public variables

var hipChatConfig = HipChatConfig()

// MARK: - HipChat Api configurable parameters

class HipChatConfig {
    
    // MARK: - Private structs
    
    private struct Constants
    {
        static let apiTokenKey = "HipChatConfig.ApiToken"
    }
    
    // MARK: - Private variables
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - HipChat Api token
    
    var currentToken: String {
        get {
            return defaults.objectForKey(Constants.apiTokenKey) as? String ?? ""
        }
        set {
            defaults.setObject(newValue, forKey: Constants.apiTokenKey)
        }
    }
    
}