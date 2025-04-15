//
//  MyPageModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import Foundation

struct MyPage: Codable {
    let nickname: String
    let characterID: Int?
    let characterImage: String?
    let backgroundID: Int?
    let backgroundImage: String?
    let point: Int
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case characterID = "characterId"
        case characterImage = "characterImageName"
        case backgroundID = "backgroundId"
        case backgroundImage = "backgroundImageName"
        case point
    }
}
