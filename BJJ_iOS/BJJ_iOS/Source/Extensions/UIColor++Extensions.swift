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
    case dropDownGray
    case red
    case blue
    case black
    case white
    case lineColor
    case warningRed
}

extension UIColor {
    
    static func customColor(_ color: Colors) -> UIColor {
        
        switch color {
        case .mainColor:
            return #colorLiteral(red: 1.0, green: 0.47058824, blue: 0.0, alpha: 1)

        case .subColor:
            return #colorLiteral(red: 1.0, green: 0.95686275, blue: 0.8745098, alpha: 1)
            
        case .backgroundGray:
            return #colorLiteral(red: 0.96470588, green: 0.96470588, blue: 0.97254902, alpha: 1)
            
        case .darkGray:
            return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            
        case .midGray:
            return #colorLiteral(red: 0.7254902, green: 0.7254902, blue: 0.7254902, alpha: 1)
            
        case .lightGray:
            return #colorLiteral(red: 0.85098039, green: 0.85098039, blue: 0.85098039, alpha: 1)
            
        case .dropDownGray:
            return #colorLiteral(red: 0.93333333, green: 0.93333333, blue: 0.93333333, alpha: 1)
            
        case .red:
            return #colorLiteral(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
            
        case .blue:
            return #colorLiteral(red: 0.0, green: 0.4, blue: 1.0, alpha: 1)
            
        case .black:
            return #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
            
        case .white:
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
            
        case .lineColor:
            return #colorLiteral(red: 0.6627451, green: 0.6627451, blue: 0.6627451, alpha: 1)
            
        case .warningRed:
            return #colorLiteral(red: 1.0, green: 0.22352941, blue: 0.08627451, alpha: 1)
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
