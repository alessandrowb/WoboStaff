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
    
    // MARK: - Model
    
    var thisUser :WoboUser?
    {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private functions
    
    private func updateUI()
    {
        userNameLabel?.text = nil
        userTitleLabel?.text = nil
        userImage?.image = nil
        
        if let thisUser = self.thisUser {
            setUserNameLabel(thisUser)
            setUserTitleLabel(thisUser)
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