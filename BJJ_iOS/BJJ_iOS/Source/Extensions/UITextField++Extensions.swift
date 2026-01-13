//
//  UITextField++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import UIKit

extension UITextField {
    
    // placeholder 설정
    func setPlaceholder(color: UIColor, font: Fonts = .pretendard, size: CGFloat = 13) {
        guard let placeholder = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: color,
            .font: UIFont.customFont(font, size)
        ])
    }
    
    // textField 왼쪽 여백 설정
    func addLeftPadding(_ width: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0))
        self.leftViewMode = .always
    }
    
    // textField 설정
    func setTextField(
        placeholder: String,
        placeholderColor: UIColor = .D_9_D_9_D_9,
        font: Fonts,
        size: CGFloat,
        textColor: UIColor = .black,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self.textColor = textColor
        self.font = .customFont(font, size)
        self.layer.masksToBounds = true
        self.setPlaceholder(color: placeholderColor)
        self.isSecureTextEntry = isSecure
    }
    
    // textField 설정 (backgroundColor, cornerRadius)
    func setTextField(
        placeholder: String,
        placeholderColor: UIColor = .D_9_D_9_D_9,
        font: Fonts,
        size: CGFloat,
        textColor: UIColor = .black,
//        backgroundColor: UIColor = .background,
//        cornerRadius: CGFloat = 10,
        leftPadding: CGFloat = 6,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self.textColor = textColor
        self.font = .customFont(font, size)
//        self.backgroundColor = backgroundColor
//        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.setPlaceholder(color: placeholderColor)
        self.addLeftPadding(leftPadding)
        self.isSecureTextEntry = isSecure
    }
}
