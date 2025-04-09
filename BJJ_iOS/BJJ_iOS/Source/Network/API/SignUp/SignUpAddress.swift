//
//  LoginAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import Foundation

enum SignUpAddress {
    case checkNickname
    case signUp
}

extension SignUpAddress {
    var url: String {
        switch self {
        case .checkNickname:
            return "members/check-nickname"
        case .signUp:
            return "members/sign-up"
        }
    }
}
