//
//  UIImage++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/3/24.
//

import UIKit

extension UIImage {
    
    /// 이미지 리사이징
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
