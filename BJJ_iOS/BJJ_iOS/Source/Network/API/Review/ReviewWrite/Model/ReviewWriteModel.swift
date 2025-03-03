//
//  ReviewWriteModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/3/25.
//

import Foundation

struct ReviewWriteMenuInfo: Hashable, Codable {
    let menuPairID: String
    let mainMenuName: String
    
    enum CodingKeys: String, CodingKey {
        case menuPairID = "menuPairId"
        case mainMenuName
    }
}
