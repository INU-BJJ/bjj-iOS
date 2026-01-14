//
//  LoginViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/4/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
@preconcurrency import WebKit

@MainActor
final class LoginViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = LoginViewModel()
    
    // MARK: - Subjects
    
    private let webViewNavigationSubject = PublishSubject<String>()
    private let navigationPolicySubject = PublishSubject<(WKNavigationActionPolicy) -> Void>()
    
    // MARK: - UI Components
    
    private let logoIcon = UIImageView().then {
        $0.setImage(.logo)
        $0.contentMode = .scaleAspectFill
    }
    
    private let appTitleLabel = UILabel().then {
        $0.setLabelUI("밥점줘", font: .cafe24Ssurround, size: 23, color: .mainColor)
    }
    
    private let greetingBubbleLabel1 = PaddingLabel(
        padding: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    ).then {
        $0.setLabelUI("학식 뭐가 제일 맛있지?", font: .pretendard_bold, size: 15, color: .mainColor)
        $0.backgroundColor = .customColor(.subColor)
        $0.setCornerRadius(radius: 10)
    }
    
    private let greetingBubbleLabel2 = PaddingLabel(
        padding: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    ).then {
        $0.setLabelUI("지금 바로 평점을 남겨봐~", font: .pretendard_bold, size: 15, color: .mainColor)
        $0.backgroundColor = .customColor(.subColor)
        $0.setCornerRadius(radius: 10)
    }
    
    private let greetingBubbleLabel3 = PaddingLabel(
        padding: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    ).then {
        $0.setLabelUI("식당 정보랑 메뉴도 바로 알 수 있어!", font: .pretendard_bold, size: 15, color: .mainColor)
        $0.backgroundColor = .customColor(.subColor)
        $0.setCornerRadius(radius: 10)
    }
    
    private let loginStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 11
        $0.alignment = .center
    }
    
    private let googleLoginButton = IconConfirmButton(
        icon: .google,
        text: "구글로 시작하기",
        backgroundColor: .white
    ).then {
        $0.setBorder(color: .customColor(.midGray))
    }

    private let kakaoLoginButton = IconConfirmButton(
        icon: .kakao,
        text: "카카오로 시작하기",
        backgroundColor: .kakaoYellow
    )

    private let naverLoginButton = IconConfirmButton(
        icon: .naver,
        text: "네이버로 시작하기",
        titleColor: .white,
        backgroundColor: .naverGreen
    )
    
    private var loginWebView: WKWebView?
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            logoIcon,
            appTitleLabel,
            greetingBubbleLabel1,
            greetingBubbleLabel2,
            greetingBubbleLabel3,
            loginStackView
        ].forEach(view.addSubview)
        
        [
            googleLoginButton,
            kakaoLoginButton,
            naverLoginButton
        ].forEach(loginStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        logoIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(141)
            $0.centerX.equalToSuperview()
        }
        
        appTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoIcon.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        greetingBubbleLabel1.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(77)
            $0.leading.equalToSuperview().offset(17)
        }
        
        greetingBubbleLabel2.snp.makeConstraints {
            $0.top.equalTo(greetingBubbleLabel1.snp.bottom).offset(25)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        greetingBubbleLabel3.snp.makeConstraints {
            $0.top.equalTo(greetingBubbleLabel2.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(33)
        }
        
        loginStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        googleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        naverLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Bind

    override func bind() {
        let input = LoginViewModel.Input(
            googleLoginTap: googleLoginButton.rx.tap.asObservable(),
            kakaoLoginTap: kakaoLoginButton.rx.tap.asObservable(),
            naverLoginTap: naverLoginButton.rx.tap.asObservable(),
            webViewNavigation: webViewNavigationSubject.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 웹뷰 표시
        output.showWebView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] request in
                self?.showWebView(with: request)
            })
            .disposed(by: disposeBag)
        
        // 회원가입 화면으로 이동
        output.navigateToSignUp
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] signUpData in
                self?.navigateToSignUp(with: signUpData)
            })
            .disposed(by: disposeBag)
        
        // 탭바로 이동
        output.navigateToTabBar
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigateToTabBar()
            })
            .disposed(by: disposeBag)
        
        // 웹뷰 닫기
        output.dismissWebView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 네비게이션 정책 처리
        Observable.zip(navigationPolicySubject, output.navigationPolicy)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { handler, policy in
                switch policy {
                case .allow:
                    handler(.allow)
                case .cancel:
                    handler(.cancel)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func showWebView(with request: WebViewRequest) {
        let webViewConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        self.loginWebView = webView
        
        let urlRequest = URLRequest(url: request.url)
        let webVC = UIViewController()
        
        webView.load(urlRequest)
        webVC.view = webView
        present(webVC, animated: true)
    }
    
    private func navigateToSignUp(with data: SignUpData) {
        let signUpViewModel = SignUpViewModel(email: data.email, provider: data.provider)
        let signUpVC = SignUpViewController(viewModel: signUpViewModel)
        
        if let navigationController = navigationController {
            navigationController.pushViewController(signUpVC, animated: true)
        } else {
            print("<< [LoginVC] navigationController가 nil입니다. pushViewController 실패")
        }
    }
    
    private func navigateToTabBar() {
        let tabBarController = TabBarController()
        navigationController?.setViewControllers([tabBarController], animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        // URL을 ViewModel로 전달
        webViewNavigationSubject.onNext(url)
        
        // decisionHandler를 저장하여 ViewModel의 판단을 기다림
        navigationPolicySubject.onNext(decisionHandler)
    }
}
