//
//  ReviewStarSize.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/10/25.
//

import UIKit

enum StarSizeType {
    case small
    case big

    var filledStarImage: UIImage? {
        
        switch self {
        case .small:
            return UIImage(named: "Star")
        case .big:
            return UIImage(named: "BigStar")
        }
    }

    var emptyStarImage: UIImage? {
        
        switch self {
        case .small:
            return UIImage(named: "EmptyStar")
        case .big:
            return UIImage(named: "BigEmptyStar")
        }
    }

    var starSize: CGSize {
        
        switch self {
        case .small:
            return CGSize(width: 12.0, height: 11.2)
        case .big:
            return CGSize(width: 34.58, height: 32.27)
        }
    }

    var stackViewSpacing: CGFloat {
        
        switch self {
        case .small:
            return 4
        case .big:
            return 11.53
        }
    }
}
