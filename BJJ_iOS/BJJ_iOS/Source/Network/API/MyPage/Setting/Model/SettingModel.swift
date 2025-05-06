//
//  SettingModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import Foundation

struct NicknameEditModel: Codable {
    let nickname: String
}

struct LikedMenuModel: Codable {
    let menuID: Int
    let menuName: String
    
    enum CodingKeys: String, CodingKey {
        case menuID = "menuId"
        case menuName
    }
}
