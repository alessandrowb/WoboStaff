//
//  UIBorderedLabel.swift
//  WoboStaff
//
//  Created by Alessandro on 1/3/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit

class UIBorderedLabel: UILabel {
    
    var topInset: CGFloat = 0
    var rightInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 5
    
    override func drawTextInRect(rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
}