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
    
    func numberOfLines() -> Int {
        // TODO: 현재는 textKit1 적용중. 추후에는 iOS 16이상부턴 textKit2 적용하기
        
        let layoutManager = self.layoutManager
        var line = 0, glyph = 0, range = NSRange()

        // maximumNumberOfLines 임시 해제
        let originalMax = self.textContainer.maximumNumberOfLines
        
        self.textContainer.maximumNumberOfLines = 0
        layoutManager.ensureLayout(for: self.textContainer)

        while glyph < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentUsedRect(forGlyphAt: glyph, effectiveRange: &range)
            glyph = NSMaxRange(range)
            line += 1
        }
        self.textContainer.maximumNumberOfLines = originalMax
        
        return line
    }
}
