//
//  MKColor.swift
//  MKFadeLabel
//
//  Created by AC-Mac on 07/12/2017.
//  Copyright © 2017 MackChan  minhechen@gmail.com. All rights reserved.
//

import UIKit

class MKColor: NSObject {
    
    // get color with red,green,blue and alpha value
    class func withRgba(_ r:Float, g:Float, b:Float, a:Float) -> UIColor {
        let color = UIColor.init(colorLiteralRed: r, green: g, blue: b, alpha: a)
        return color
    }
    
    // get color with hex string
    class func withHex(_ hexString: String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
