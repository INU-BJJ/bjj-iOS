//
//  LoginAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import UIKit

final class LoginAPI {
    static func postLoginToken(params: [String: String], completion: @escaping (Result<LoginModel, Error>) -> Void) {
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        networkRequest(
            urlStr: LoginAddress.signUp.url,
            method: .post,
            data: data,
            model: LoginModel.self,
            completion: completion
        )
    }
}
