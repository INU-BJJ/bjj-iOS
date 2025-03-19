//
//  RankingAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/17/25.
//

import Foundation

enum RankingAddress {
    case fetchMenuRanking
    
    var url: String {
        switch self {
        case .fetchMenuRanking:
            return "menus/ranking"
        }
    }
}
