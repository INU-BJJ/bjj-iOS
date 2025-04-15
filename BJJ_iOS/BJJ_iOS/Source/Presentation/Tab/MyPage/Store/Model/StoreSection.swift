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
