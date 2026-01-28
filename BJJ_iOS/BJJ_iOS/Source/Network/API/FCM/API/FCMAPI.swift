//
//  FCMAPI.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/28/26.
//

import Alamofire

final class FCMAPI {
    
    /// fcm 토큰 등록
    static func registerFCMToken(fcmToken: String, completion: @escaping (Result<Int, Error>) -> Void) {
        networkRequest(
            urlStr: FCMPath.registerFCMToken.url,
            method: .post,
            data: nil,
            model: Int.self,
            query: ["token": fcmToken],
            completion: completion
        )
    }
}
