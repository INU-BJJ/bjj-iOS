//
//  SettingAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import Foundation

enum SettingAddress {
    case patchNickname
    case fetchLikedMenu
    
    var url: String {
        switch self {
        case .patchNickname:
            return "members/nickname"
        case .fetchLikedMenu:
            return "menus/liked"
        }
    }
}
