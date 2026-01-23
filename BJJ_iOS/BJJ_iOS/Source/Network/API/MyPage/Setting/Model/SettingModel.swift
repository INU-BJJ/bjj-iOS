//
//  SettingModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import Foundation

// 닉네임 수정
struct NicknameEditModel: Codable {
    let nickname: String
}

// 좋아요한 메뉴
struct LikedMenuModel: Codable {
    let menuID: Int
    let menuName: String
    
    enum CodingKeys: String, CodingKey {
        case menuID = "menuId"
        case menuName
    }
}
