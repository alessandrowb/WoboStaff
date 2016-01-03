//
//  ImageLoadingWithCache.swift
//  WoboStaff
//
//  Created by Alessandro on 1/2/16.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Public variables

var cache = ImageLoadingWithCache()
var imageCache = [String:UIImage]()

// MARK :- Caching system

class ImageLoadingWithCache
{
    func getImage(url: String, imageView: UIImageView)
    {
        if let img = imageCache[url] {
            imageView.image = img
        } else {
            let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    imageCache[url] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = image
                    })
                }
                else {
                    imageView.image = nil
                }
            }
            task.resume()
        }
    }
}