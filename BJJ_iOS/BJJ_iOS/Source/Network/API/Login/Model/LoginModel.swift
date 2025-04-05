//
//  LoginModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import Foundation

struct LoginModel: Hashable, Codable {
    let loginToken: String
    
    enum CodingKeys: String, CodingKey {
        case loginToken = "token"
    }
}
