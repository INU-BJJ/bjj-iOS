//
//  StoreSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

struct StoreSection: Hashable {
    let itemID: Int
    let itemName: String
    let itemType: String
    let itemRarity: String
    let itemImage: String
    let validPeriod: String?
    let isWearing: Bool
    let isOwned: Bool
}

enum ItemRarity: String {
    case common = "COMMON"
    case normal = "NORMAL"
    case rare = "RARE"

    var koreanTitle: String {
        switch self {
        case .common: 
            return "흔함"
        case .normal: 
            return "보통"
        case .rare: 
            return "희귀"
        }
    }
}
