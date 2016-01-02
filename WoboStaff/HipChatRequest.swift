//
//  HipChatRequest.swift
//  WoboStaff
//
//  Created by Alessandro on 12/31/15.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import Foundation

class HipChatRequest {
    
    // MARK: - Private structs
    
    private struct HipChatConfig {
        static let HipChatApiUrl = "https://api.hipchat.com/v2/user?expand=items&auth_token="
        static let HipChatApiToken = ConfigFile.sharedInstance.hipChatToken
        static let HipChatLocalJson = "WoboUsers.json"
    }
    
    // MARK: - Private variables
    
    private var woboFileName = HipChatConfig.HipChatLocalJson
    
    private let request :NSURL? = NSURL(string: HipChatConfig.HipChatApiUrl + HipChatConfig.HipChatApiToken)
    
    func returnUrl() -> String
    {
        return request!.absoluteString
    }
    
    // MARK: - Public functions
    
    func fetchAndReturnUsers() -> JSON?
    {
        if let data = NSData(contentsOfURL: request!) {
            do {
                try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                let json = JSON(data: data)
                return json
            } catch  {
                //Could not convert data to JSON
                return nil
            }
        }
        else {
            //Could not retrieve data from the network
            return nil
        }
    }
    
    func fetchAndSaveUsers()
    {
        if let data = NSData(contentsOfURL: request!) {
            do {
                try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                let json = JSON(data: data)
                let data = json.rawString()!.dataUsingEncoding(NSUTF8StringEncoding)!
                if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                    let path = dir.stringByAppendingPathComponent(woboFileName);
                    data.writeToFile(path, atomically: false)
                }
            } catch  {
                //Could not convert data to JSON
                return
            }
        }
    }
    
    func readUsersFromFile() -> JSON?
    {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(woboFileName);
            let jsonString = NSData(contentsOfFile: path)
            if let json :JSON? = JSON(data: jsonString!) {
                return json
            }
            else {
                //Could not find a valid JSON in the file system
                return nil
            }
        }
        else {
            //Could not access file system
            return nil
        }
    }
    
}

// MARK: - Support Classes

private class ConfigFile
{
    class var sharedInstance: ConfigFile {
        struct Singleton {
            static let instance = ConfigFile()
        }
        return Singleton.instance
    }
    
    private var configValues: NSDictionary!
    
    required init() {
        let filePath = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!
        self.configValues = NSDictionary(contentsOfFile:filePath)
    }
    
    var hipChatToken: String {
        get {
            return configValues["HipChatToken"] as! String
        }
    }
}