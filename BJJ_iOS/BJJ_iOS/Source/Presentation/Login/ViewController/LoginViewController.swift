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
final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let LOGIN_URL = "https://bjj.inuappcenter.kr/oauth2/authorization/"
    private let NAVER = "naver"
    
    // MARK: - UI Components
    
    private lazy var naverLoginButton = UIButton().then {
        $0.setTitle("네이버", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didTapNaverLogin), for: .touchUpInside)
    }
    
    private var loginWebView: WKWebView?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            naverLoginButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        naverLoginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapNaverLogin() {
        let webViewConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        self.loginWebView = webView
        
        guard let url = URL(string: LOGIN_URL + NAVER) else { return }
        
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
            
            // 이미 회원가입이 되어 있는 경우 (로그인 진행)
            if url.starts(with: "https://bjj.inuappcenter.kr/api/members/success") {
                if let components = URLComponents(string: url) {
                    let queryItems = components.queryItems ?? []
                    let token = queryItems.first(where: { $0.name == "token" })?.value
                    
                    if let token = token {
                        print("🔐 Token: \(token)")
                    }
                }
                
                decisionHandler(.cancel)
                dismiss(animated: true)
                return
            }
            
            // 처음 회원가입하는 경우 (회원가입 진행)
            if url.starts(with: "https://bjj.inuappcenter.kr/api/members/sign-up") {
                if let components = URLComponents(string: url) {
                    let queryItems = components.queryItems ?? []
                    
                    let email = queryItems.first(where: { $0.name == "email" })?.value
                    let token = queryItems.first(where: { $0.name == "token" })?.value
                    
                    if let email = email {
                        print("✅ Email: \(email)")
                    }
                    
                    if let token = token {
                        print("🔐 Token: \(token)")
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
