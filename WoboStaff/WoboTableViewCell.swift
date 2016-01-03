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

    @IBOutlet weak var userNameLabel: UIBorderedLabel!
    @IBOutlet weak var userTitleLabel: UIBorderedLabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userOnlineStatusLabel: UIBorderedLabel!
    
    // MARK: - Model
    
    var thisUser :WoboUser?
    {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private structs
    
    private struct Constants
    {
        static let onlineColor = UIColor.greenColor()
        static let awayColor = UIColor(red: 0.8275, green: 0.8275, blue: 0.3804, alpha: 1.0) /* #d3d361 */
        static let dndColor = UIColor.orangeColor()
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
            setCacheImage(thisUser)
        }
    }
    
    // MARK: - Wobo Cell Content
    
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
        if user.onlineStatus != nil {
            switch user.onlineStatus! {
                case "Idle":
                    statusColor = Constants.awayColor
                case "Online":
                    statusColor = Constants.onlineColor
                case "Busy":
                    statusColor = Constants.dndColor
                case "Mobile":
                    statusColor = Constants.mobileColor
                case "Offline":
                    statusColor = Constants.offlineColor
                default:
                    break
            }
        }
        userOnlineStatusLabel?.text = user.onlineStatus
        userOnlineStatusLabel?.textColor = statusColor
    }
    
    private func setCacheImage (user :WoboUser)
    {
        if user.imgUrl != nil {
            cache.getImage(user.imgUrl!, imageView: userImage)
        }
    }

}

// MARK: - Support Classes

class UIBorderedLabel: UILabel {
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 5
    
    override func drawTextInRect(rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}