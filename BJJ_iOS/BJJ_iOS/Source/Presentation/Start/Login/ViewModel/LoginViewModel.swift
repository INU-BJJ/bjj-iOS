//
//  LoginViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    // MARK: - Input

    struct Input {
        let googleLoginTap: Observable<Void>
        let kakaoLoginTap: Observable<Void>
        let naverLoginTap: Observable<Void>
        let webViewNavigation: Observable<String>
    }

    // MARK: - Output

    struct Output {
        let showWebView: Observable<WebViewRequest>
        let navigateToSignUp: Observable<SignUpData>
        let navigateToTabBar: Observable<Void>
        let dismissWebView: Observable<Void>
        let navigationPolicy: Observable<NavigationPolicy>
    }

    // MARK: - Properties

    private let currentLoginType = BehaviorSubject<SocialLoginType?>(value: nil)

    // MARK: - Transform

    func transform(input: Input) -> Output {
        // 로그인 버튼 탭 처리
        let googleLogin = input.googleLoginTap
            .map { SocialLoginType.google }
        
        let kakaoLogin = input.kakaoLoginTap
            .map { SocialLoginType.kakao }

        let naverLogin = input.naverLoginTap
            .map { SocialLoginType.naver }

        let loginTypeTapped = Observable.merge(googleLogin, kakaoLogin, naverLogin)
            .do(onNext: { [weak self] loginType in
                self?.currentLoginType.onNext(loginType)
            })

        let showWebView = loginTypeTapped
            .compactMap { loginType -> WebViewRequest? in
                guard let url = URL(string: baseURL.LOGIN_URL + loginType.provider) else {
                    return nil
                }
                return WebViewRequest(url: url, loginType: loginType)
            }

        // 웹뷰 네비게이션 URL 처리
        let navigationResult = input.webViewNavigation
            .share()

        // 회원가입 케이스
        let signUpCase = navigationResult
            .filter { $0.starts(with: baseURL.signUpURL) }
            .compactMap { urlString -> (email: String, token: String)? in
                guard let components = URLComponents(string: urlString) else {
                    return nil
                }

                let queryItems = components.queryItems ?? []
                let email = queryItems.first(where: { $0.name == "email" })?.value
                let token = queryItems.first(where: { $0.name == "token" })?.value

                if let email = email, let token = token {
                    return (email, token)
                }

                return nil
            }
            .share()

        let navigateToSignUp = signUpCase
            .withLatestFrom(currentLoginType) { signUpData, loginType -> SignUpData? in
                guard let loginType = loginType else { return nil }
                return SignUpData(
                    email: signUpData.email,
                    provider: loginType.provider
                )
            }
            .compactMap { $0 }

        let signUpToken = signUpCase
            .map { $0.token }
            .do(onNext: { token in
                KeychainManager.create(value: token, key: .tempToken)
            })
            .map { _ in }

        // 로그인 케이스
        let loginCase = navigationResult
            .filter { $0.starts(with: baseURL.socialLoginURL) }
            .compactMap { urlString -> String? in
                guard let components = URLComponents(string: urlString) else {
                    return nil
                }
                
                let queryItems = components.queryItems ?? []
                return queryItems.first(where: { $0.name == "token" })?.value
            }

        let navigateToTabBar = loginCase
            .do(onNext: { token in
                KeychainManager.create(value: token, key: .accessToken)
                
                // 로그인 성공 시 저장된 FCM 토큰을 서버에 전송
                if let fcmToken = UserDefaultsManager.shared.readString(.fcmToken) {
                    FCMAPI.registerFCMToken(fcmToken: fcmToken) { _ in }
                }
            })
            .map { _ in }

        // 웹뷰 닫기 (회원가입 또는 로그인 케이스)
        let dismissWebView = Observable.merge(
            signUpToken,
            navigateToTabBar
        )

        // 네비게이션 정책
        let navigationPolicy = navigationResult
            .map { urlString -> NavigationPolicy in
                if urlString.starts(with: baseURL.signUpURL) ||
                   urlString.starts(with: baseURL.socialLoginURL) {
                    return .cancel
                }
                return .allow
            }

        return Output(
            showWebView: showWebView,
            navigateToSignUp: navigateToSignUp,
            navigateToTabBar: navigateToTabBar,
            dismissWebView: dismissWebView,
            navigationPolicy: navigationPolicy
        )
    }
}
