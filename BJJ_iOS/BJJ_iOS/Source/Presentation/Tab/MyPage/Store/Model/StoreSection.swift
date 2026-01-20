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
    let itemType: ItemType
    let itemRarity: ItemRarity
    let itemImage: String
    let validPeriod: String?
    let isWearing: Bool
    let isOwned: Bool
}

enum ItemType: String {
    case character = "CHARACTER"
    case background = "BACKGROUND"

    var title: String {
        switch self {
        case .character:
            return "캐릭터"
        case .background:
            return "배경"
        }
    }
}

enum ItemRarity: String {
    case `default` = "DEFAULT"
    case common = "COMMON"
    case normal = "NORMAL"
    case rare = "RARE"

    var title: String {
        switch self {
        case .default, .common:
            return "흔함"
        case .normal:
            return "보통"
        case .rare:
            return "희귀"
        }
    }
}
