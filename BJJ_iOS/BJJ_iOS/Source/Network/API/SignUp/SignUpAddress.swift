//
//  LoginAddress.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/5/25.
//

import Foundation

enum SignUpAddress {
    case signUp
    
    var url: String {
        switch self {
        case .signUp:
            return "members/sign-up"
        }
    }
}
