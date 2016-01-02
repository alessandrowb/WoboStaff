//
//  WoboTableViewCell.swift
//  WoboStaff
//
//  Created by Alessandro on 12/31/15.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class WoboTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userOnlineStatusLabel: UILabel!
    
    // MARK: - Model
    
    var thisUser :WoboUser?
    {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private structs
    
    private struct Constants {
        static let onlineColor = UIColor.greenColor()
        static let awayColor = UIColor.yellowColor()
        static let dndColor = UIColor.brownColor()
        static let mobileColor = UIColor.blueColor()
        static let offlineColor = UIColor.redColor()
        static let defaultColor = UIColor.blackColor()
    }
    
    // MARK: - Private functions
    
    private func updateUI()
    {
        userNameLabel?.text = nil
        userTitleLabel?.text = nil
        userOnlineStatusLabel?.text = nil
        userImage?.image = nil
        
        if let thisUser = self.thisUser {
            setUserNameLabel(thisUser)
            setUserTitleLabel(thisUser)
            setUserOnlineStatus(thisUser)
            setUserImageView(thisUser)
        }
    }
    
    private func setUserNameLabel (user :WoboUser)
    {
        userNameLabel?.text = user.name
    }
    
    private func setUserTitleLabel (user :WoboUser)
    {
        userTitleLabel?.text = user.title
    }
    
    private func setUserOnlineStatus (user: WoboUser)
    {
        var statusColor = Constants.defaultColor
        switch user.onlineStatus {
            case "away":
                statusColor = Constants.awayColor
            case "online":
                statusColor = Constants.onlineColor
            case "dnd":
                statusColor = Constants.dndColor
            case "xa":
                statusColor = Constants.mobileColor
            case "offline":
                statusColor = Constants.offlineColor
            default:
                break
        }
        userOnlineStatusLabel?.text = user.onlineStatus
        userOnlineStatusLabel?.textColor = statusColor
    }
    
    private func setUserImageView (user :WoboUser)
    {
        let fileUrl = NSURL(string: user.imgUrl)
        if let profileImageURL = fileUrl {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.userImage?.image = UIImage(data: imageData)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.userImage?.image = nil
                    }
                }
            }
        }
    }

}