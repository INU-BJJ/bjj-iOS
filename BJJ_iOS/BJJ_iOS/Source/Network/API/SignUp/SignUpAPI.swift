//
//  LoginAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import UIKit

final class SignUpAPI {
    static func postNickname(nickname: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        networkRequest(
            urlStr: SignUpAddress.checkNickname.url,
            method: .post,
            data: nil,
            model: Bool.self,
            query: [
                "nickname": nickname
            ],
            completion: completion
        )
    }
    
    static func postLoginToken(params: [String: String], completion: @escaping (Result<SignUpModel, Error>) -> Void) {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        networkRequest(
            urlStr: SignUpAddress.signUp.url,
            method: .post,
            data: data,
            model: SignUpModel.self,
            completion: completion
        )
    }
}
