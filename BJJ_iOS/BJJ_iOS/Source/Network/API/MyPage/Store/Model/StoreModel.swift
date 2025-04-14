//
//  StoreModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import Foundation

// TODO: 파일이 다른데 응답 모델이 같은 경우(GachaResultModel과 동일) 어떻게 처리할지 고민
struct StoreModel: Codable {
    let itemID: Int
    let itemName: String
    let itemType: String
    let itemRarity: String
    let itemImage: String
    let validPeriod: String
    let isWearing: Bool
    let isOwned: Bool
    
    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemName
        case itemType
        case itemRarity = "itemLevel"
        case itemImage = "imageName"
        case validPeriod
        case isWearing
        case isOwned
    }
}
