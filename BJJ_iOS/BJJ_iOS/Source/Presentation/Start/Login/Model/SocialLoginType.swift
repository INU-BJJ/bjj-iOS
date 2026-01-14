//
//  SocialLoginType.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

enum SocialLoginType: Int {
    case google = 0
    case kakao = 1
    case naver = 2
    case apple = 3

    var provider: String {
        switch self {
        case .google:
            return "google"
        case .kakao:
            return "kakao"
        case .naver:
            return "naver"
        case .apple:
            return "apple"
        }
    }
}
