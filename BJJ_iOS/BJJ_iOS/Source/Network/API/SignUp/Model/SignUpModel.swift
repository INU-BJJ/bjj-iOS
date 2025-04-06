//
//  LoginModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import Foundation

struct SignUpModel: Hashable, Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
    }
}
