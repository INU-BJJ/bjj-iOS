//
//  UITextView++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit

extension UITextView {
    
    func setTextViewUI(_ text: String, font: Fonts, size: CGFloat, color: Colors) {
        self.textColor = .customColor(color)
        self.font = .customFont(font, size)
        self.text = text
    }
}
