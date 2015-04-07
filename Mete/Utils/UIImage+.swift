//
//  UIImage+.swift
//  Mete
//
//  Created by Nate Armstrong on 4/6/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import Foundation

extension UIImage {
  class func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)

    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
  }
}
