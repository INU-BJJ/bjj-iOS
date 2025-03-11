//
//  NoticeViewType.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/6/25.
//

import Foundation

enum NoticeViewType {
    case home
    case review
    
    var message: String {
        switch self {
        case .home:
            return "오늘은 운영을 안해요!"
        
        case .review:
            return "리뷰를 추가해주세요!"
        }
    }
}
