//
//  StringExtensions.swift
//  WoboStaff
//
//  Created by Alessandro on 1/10/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import Foundation

extension String {
    
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}