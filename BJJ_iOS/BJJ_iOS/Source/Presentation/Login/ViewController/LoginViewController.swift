//
//  LoginViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/4/25.
//

import UIKit
import SnapKit
import Then
import WebKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let naverLoginURL = "https://bjj.inuappcenter.kr/oauth2/authorization/naver"
    
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
//        webView.navigationDelegate = self
        self.loginWebView = webView
        
        guard let url = URL(string: naverLoginURL) else { return }
        
        let request = URLRequest(url: url)
        let webVC = UIViewController()
        
        webView.load(request)
        webVC.view = webView
        present(webVC, animated: true)
    }
}
