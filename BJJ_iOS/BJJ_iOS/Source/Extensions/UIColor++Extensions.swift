//
//  UIColor++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit

enum Colors {
    case mainColor
    case subColor
    case backgroundGray
    case darkGrey
    case midGrey
    case lightGrey
    case customRed
    case customBlue
}

extension UIColor {
    
    static func customColor(_ color: Colors) -> UIColor {
        
        switch color {
        case .mainColor:
            return UIColor(hexCode: "FF7800")
            
        case .subColor:
            return UIColor(hexCode: "FFF4DF")
            
        case .backgroundGray:
            return UIColor(hexCode: "F6F6F8")
            
        case .darkGrey:
            return UIColor(hexCode: "999999")
            
        case .midGrey:
            return UIColor(hexCode: "B9B9B9")
            
        case .lightGrey:
            return UIColor(hexCode: "D9D9D9")
            
        case .customRed:
            return UIColor(hexCode: "FF0000")
            
        case .customBlue:
            return UIColor(hexCode: "0066FF")
        }
    }
}

extension UIColor {
    // hex값으로 초기화
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
