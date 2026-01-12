//
//  UIImageView++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/12/26.
//

import UIKit

enum ImageAsset: String {
    case logo
    
    var name: String {
        rawValue
    }
}

extension UIImageView {
    
    // 이미지 설정
    func setImage(_ image: ImageAsset) {
        self.image = UIImage(named: image.name)
    }
}
