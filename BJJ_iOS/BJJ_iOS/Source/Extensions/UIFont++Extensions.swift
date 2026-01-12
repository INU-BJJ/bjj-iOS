//
//  UIFont++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/6/24.
//

import UIKit
import PretendardKit

enum Fonts {
    case pretendard_bold        // 700
    case pretendard_semibold    // 600
    case pretendard_medium      // 500
    case pretendard // pretendard_regular와 같음. 400
    case pretendard_light       // 300
    case racingSansOne
    case cafe24Ssurround
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
        case .pretendard:
            return .pretendard(ofSize: size, weight: .regular)
        case .pretendard_light:
            return .pretendard(ofSize: size, weight: .light)
        case .racingSansOne:
            return UIFont(name: "RacingSansOne-Regular", size: size) ?? .pretendard(ofSize: size, weight: .medium)
        case .cafe24Ssurround:
            return UIFont(name: "Cafe24Ssurround", size: size) ?? .pretendard(ofSize: size, weight: .medium)
        }
    }
}
