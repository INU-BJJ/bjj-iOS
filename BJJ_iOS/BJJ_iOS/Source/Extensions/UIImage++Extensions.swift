//
//  UIImage++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/3/24.
//

import UIKit

extension UIImage {
    
    // 이미지 리사이징 (고화질)
    func resize(to size: CGSize) -> UIImage {
        // 원본 이미지의 scale을 유지하거나, 최소 화면의 scale을 사용
        let scale = max(self.scale, UIScreen.main.scale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false
        
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            // 고품질 interpolation 설정
            context.cgContext.interpolationQuality = .high
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
