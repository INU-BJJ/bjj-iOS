//
//  LoginViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/4/25.
//

import UIKit
import SnapKit
import Then
@preconcurrency import WebKit

@MainActor
final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let LOGIN_URL = "https://bjj.inuappcenter.kr/oauth2/authorization/"
    private var provider = ""
    
    // MARK: - UI Components
    
    private let logoIcon = UIImageView().then {
        $0.setImage(.logo)
        $0.contentMode = .scaleAspectFill
    }
    
    private let testLoginStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .center
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setTitle("카카오", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.yellow.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.tag = 0
        $0.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    }
    
    private lazy var naverLoginButton = UIButton().then {
        $0.setTitle("네이버", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.tag = 1
        $0.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    }
    
    private lazy var googleLoginButton = UIButton().then {
        $0.setTitle("구글", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.tag = 2
        $0.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    }
    
    private var loginWebView: WKWebView?
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            logoIcon,
            testLoginStackView
        ].forEach(view.addSubview)
        
        [
            kakaoLoginButton,
            naverLoginButton,
            googleLoginButton
        ].forEach(testLoginStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        logoIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(141)
            $0.centerX.equalToSuperview()
        }
        
        testLoginStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        naverLoginButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapLoginButton(_ sender: UIButton) {
        let webViewConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
//        webViewConfig.applicationNameForUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
//        https://sweetcoding.tistory.com/71
        webView.navigationDelegate = self
        // TODO: userAgent 바꾸는 방법 말고 다른 방법 찾아보기
//        https://velog.io/@jijiseong/웹뷰에서-소셜-로그인시-문제-해결하기
        webView.customUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        self.loginWebView = webView
        
        // TODO: 소셜 로그인 enum으로 깔끔하게 처리하기
        switch sender.tag {
        case 0:
            provider = "kakao"
        case 1:
            provider = "naver"
        case 2:
            provider = "google"
        case 3:
            provider = "apple"
        default:
            break
        }
        
        guard let url = URL(string: LOGIN_URL + provider) else { return }
        
        let request = URLRequest(url: url)
        let webVC = UIViewController()
        
        webView.load(request)
        webVC.view = webView
        present(webVC, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            
            // 처음 회원가입하는 경우 (회원가입 진행)
            if url.starts(with: "https://bjj.inuappcenter.kr/api/members/sign-up") {
                if let components = URLComponents(string: url) {
                    let queryItems = components.queryItems ?? []
                    
                    let email = queryItems.first(where: { $0.name == "email" })?.value
                    let token = queryItems.first(where: { $0.name == "token" })?.value
                    
                    if let email = email, let token = token {
                        KeychainManager.create(token: token)
                        decisionHandler(.cancel)
                        dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            let signUpVC = SignUpViewController(email: email, provider: provider)
                            
                            if let navigationController = self.navigationController {
                                navigationController.pushViewController(signUpVC, animated: true)
                            } else {
                                print("<< [LoginVC] navigationController가 nil입니다. pushViewController 실패")
                                return
                            }
                        }
                        return
                    }
                }
                
                decisionHandler(.cancel)
                dismiss(animated: true)
                return
            }
            
            // 이미 회원가입이 되어 있는 경우 (로그인 진행)
            if url.starts(with: "https://bjj.inuappcenter.kr/api/members/success") {
                if let components = URLComponents(string: url) {
                    let queryItems = components.queryItems ?? []
                    let token = queryItems.first(where: { $0.name == "token" })?.value
                    
                    if let token = token {
                        KeychainManager.create(token: token)
                        decisionHandler(.cancel)
                        dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            
                            DispatchQueue.main.async {
                                // TODO: 로그인 후 TabBarController로 안 넘어가는 버그 발생중
                                // TODO: rootViewController를 TabBarController로 바꾸기
                                let tabBarController = TabBarController()
                                self.navigationController?.setViewControllers([tabBarController], animated: true)
                            }
                        }
                        return
                    }
                }
                
                decisionHandler(.cancel)
                dismiss(animated: true)
                return
            }
        }
        
        decisionHandler(.allow)
    }
}
