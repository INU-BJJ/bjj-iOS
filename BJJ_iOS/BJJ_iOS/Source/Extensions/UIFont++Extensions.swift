//
//  UIFont++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import PretendardKit

enum Fonts {
    case pretendard_bold
    case pretendard_semibold
    case pretendard_medium
    case pretendard_light
    case pretendard // pretendard_regular와 같음
}

extension UIFont {
    static func customFont(_ font: Fonts, _ size: CGFloat) -> UIFont {
        switch font {
        case .pretendard_bold:
            return .pretendard(ofSize: size, weight: .bold)
        case .pretendard_semibold:
            return .pretendard(ofSize: size, weight: .semibold)
        case .pretendard_medium:
            return .pretendard(ofSize: size, weight: .medium)
        case .pretendard_light:
            return .pretendard(ofSize: size, weight: .light)
        case .pretendard:
            return .pretendard(ofSize: size, weight: .regular)
        }
    }
}
