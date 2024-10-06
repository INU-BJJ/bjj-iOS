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
    case darkGray
    case midGray
    case lightGray
    case red
    case blue
    case black
    case white
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
            
        case .darkGray:
            return UIColor(hexCode: "999999")
            
        case .midGray:
            return UIColor(hexCode: "B9B9B9")
            
        case .lightGray:
            return UIColor(hexCode: "D9D9D9")
            
        case .red:
            return UIColor(hexCode: "FF0000")
            
        case .blue:
            return UIColor(hexCode: "0066FF")
            
        case .black:
            return UIColor(hexCode: "000000")
            
        case .white:
            return UIColor(hexCode: "FFFFFF")
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
