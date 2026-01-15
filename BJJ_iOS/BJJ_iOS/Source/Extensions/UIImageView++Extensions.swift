//
//  UIImageView++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/12/26.
//

import UIKit

enum ImageAsset: String {
    case logo
    case google
    case kakao
    case naver
    case bigBorderCheckBox
    case bigEmptyBorderCheckBox
    case smallBorderCheckBox
    case smallEmptyBorderCheckBox
    case checkCircleGreen
    case checkCircleWarning
    case gear
    case store
    case BlackBackButton
    case point
    case orangeInfo
    case gachaBubble
    case storeBackground
    
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
