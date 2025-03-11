//
//  UIView++Extensions.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/10/25.
//

import UIKit

enum LineStyle {
    case menuDetail         // menuDetail에서 사용된 구분선
    case menuDetailThick    // menuDetail에서 사용된 두꺼운 구분선
    case reviewWrite        // reviewWrite에서 사용된 구분선
    case custom(width: CGFloat, color: UIColor)

    var borderWidth: CGFloat {
        switch self {
        case .menuDetail:
            return 0.5
        case .menuDetailThick:
            return 7
        case .reviewWrite:
            return 0.5
        case .custom(let width, _):
            return width
        }
    }

    var borderColor: UIColor {
        switch self {
        case .menuDetail:
            return .customColor(.lineColor)
        case .menuDetailThick:
            return .customColor(.backgroundGray)
        case .reviewWrite:
            return .customColor(.midGray)
        case .custom(_, let color):
            return color
        }
    }
}
