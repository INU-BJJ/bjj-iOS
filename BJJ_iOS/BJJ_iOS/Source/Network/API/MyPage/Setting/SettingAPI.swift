//
//  SettingAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import Foundation

final class SettingAPI {
    /// 닉네임 변경
    static func patchNickname(nickname: String, completion: @escaping (Result<NicknameEditModel, Error>) -> Void) {
        networkRequest(
            urlStr: SettingAddress.patchNickname.url,
            method: .patch,
            data: nil,
            model: NicknameEditModel.self,
            query: ["nickname": nickname],
            completion: completion
        )
    }
    
    /// 좋아요한 메뉴 조회
    static func fetchLikedMenu(completion: @escaping (Result<[LikedMenuModel], Error>) -> Void) {
        networkRequest(
            urlStr: SettingAddress.fetchLikedMenu.url,
            method: .get,
            data: nil,
            model: [LikedMenuModel].self,
            completion: completion
        )
    }
    
    /// 서비스 이용약관 조회
    static func fetchServicePolicy(completion: @escaping (Result<String, Error>) -> Void) {
        networkRequest(
            urlStr: SettingAddress.fetchServicePolicy.url,
            method: .get,
            responseType: .html,
            completion: completion
        )
    }
    
    /// 개인정보 처리방침 조회
    static func fetchPersonalPolicy(completion: @escaping (Result<String, Error>) -> Void) {
        networkRequest(
            urlStr: SettingAddress.fetchPersonalPolicy.url,
            method: .get,
            responseType: .html,
            completion: completion
        )
    }
}
