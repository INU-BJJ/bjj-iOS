//
//  SocialLoginType.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import Foundation

// MARK: - 소셜 로그인 타입

enum SocialLoginType {
    case google
    case kakao
    case naver
    case apple

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

// MARK: - 웹뷰 요청

struct WebViewRequest {
    let url: URL
    let loginType: SocialLoginType
}

// MARK: - 회원가입 페이지 전달 데이터

struct SignUpData {
    let email: String
    let provider: String
}

// MARK: - 웹뷰 네비게이션 허용 여부

enum NavigationPolicy {
    case allow
    case cancel
}
