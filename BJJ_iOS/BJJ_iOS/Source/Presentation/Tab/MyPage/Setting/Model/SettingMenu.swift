//
//  SettingMenu.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

enum SettingMenu: String, CaseIterable {
    case editNickname
    case likedMenu
    case servicePolicy
    case personalPolicy
    
    var title: String {
        switch self {
        case .editNickname:
            return "닉네임 변경하기"
        case .likedMenu:
            return "좋아요한 메뉴"
        case .servicePolicy:
            return "서비스 이용 약관"
        case .personalPolicy:
            return "개인정보 처리방침"
        }
    }
}
