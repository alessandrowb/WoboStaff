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
    
    private struct Constants
    {
        static let hipChatApiUrl = "https://api.hipchat.com/v2/user?expand=items&auth_token="
        static let hipChatLocalJson = "WoboUsers.json"
        static let hipChatUnknownUserStatus = "Unknown"
    }
    
    // MARK: - Private variables
    
    private var woboFileName = Constants.hipChatLocalJson
    private var hipChatUserStatusesMap: [String: String] = ["away": "Idle", "chat": "Online", "dnd": "Busy", "xa": "Mobile"]
    
    private var request: NSURL
    {
        get {
           return NSURL(string: Constants.hipChatApiUrl + hipChatConfig.currentToken)!
        }
    }
    
    // MARK: - Public functions
    
    func returnUrl() -> String
    {
        return request.absoluteString
    }
    
    func fetchAndReturnUsers() -> JSON?
    {
        if let data = NSData(contentsOfURL: request) {
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
        if let data = NSData(contentsOfURL: request) {
            do {
                try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                let json = JSON(data: data)
                let data = json.rawString()!.dataUsingEncoding(NSUTF8StringEncoding)!
                if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
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
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(woboFileName);
            let jsonString = NSData(contentsOfFile: path)
            if let json: JSON? = JSON(data: jsonString!) {
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
    
    func getUserStatus(userStatus: String) -> String
    {
        if let thisStatus = hipChatUserStatusesMap[userStatus] {
            return thisStatus
        }
        else {
            return Constants.hipChatUnknownUserStatus
        }
    }
    
}