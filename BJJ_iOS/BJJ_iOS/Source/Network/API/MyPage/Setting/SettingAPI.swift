//
//  SettingAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import Foundation

final class SettingAPI {
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
    
    static func fetchLikedMenu(completion: @escaping (Result<[LikedMenuModel], Error>) -> Void) {
        networkRequest(
            urlStr: SettingAddress.fetchLikedMenu.url,
            method: .get,
            data: nil,
            model: [LikedMenuModel].self,
            completion: completion
        )
    }
}
