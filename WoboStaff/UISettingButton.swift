//
//  UISettingButton.swift
//  WoboStaff
//
//  Created by Alessandro on 1/10/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class UISettingButton: UIButton {
    
    // MARK: - Private structs
    
    private struct Constants
    {
        static let buttonColor = AppColors.generalSystemColor
    }
    
    // MARK: - Init for UISettingButton
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = Constants.buttonColor.CGColor
        self.setTitleColor(Constants.buttonColor, forState: UIControlState.Normal)
    }
}
