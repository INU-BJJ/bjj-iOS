//
//  SignUpViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/6/25.
//

import UIKit
import SnapKit
import Then

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let email: String
    private let provider: String
    
    // MARK: - UI Components
    
    private let testEmailLabel = UILabel().then {
        $0.setLabelUI("이메일", font: .pretendard, size: 15, color: .black)
    }
    
    private lazy var testEmailTextField = UITextField().then {
        $0.text = email
        $0.textColor = .customColor(.midGray)
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .customColor(.lightGray)
        $0.isEnabled = false
    }
    
    private let testNickNameLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard, size: 15, color: .black)
    }
    
    private lazy var testNickNameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.customColor(.midGray)
            ]
        )
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(didNicknameChange(_:)), for: .editingChanged)
    }
    
    private lazy var testIsDupliCateButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(didTapDupplicateButton), for: .touchUpInside)
    }
    
    private let testIsValidLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
        $0.isHidden = true
    }
    
    private lazy var testSignUpButton = UIButton().then {
        $0.setTitle("밥점줘 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.midGray)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    init(email: String, provider: String) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            testEmailLabel,
            testEmailTextField,
            testNickNameLabel,
            testNickNameTextField,
            testIsDupliCateButton,
            testIsValidLabel,
            testSignUpButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testIsDupliCateButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        testSignUpButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: Objc Functions
    
    @objc private func didNicknameChange(_ textField: UITextField) {
        testSignUpButton.isEnabled = false
        testSignUpButton.backgroundColor = .customColor(.midGray)
        testIsValidLabel.isHidden = true
    }
    
    @objc private func didTapDupplicateButton() {
        postNickname(nickname: testNickNameTextField.text)
    }
    
    @objc private func didTapSignUpButton() {
        postLoginToken()
    }
    
    // MARK: Post API
    
    private func postNickname(nickname: String?) {
        // 닉네임을 입력한 경우
        if let nickname = nickname, !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            SignUpAPI.postNickname(nickname: nickname) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.testIsValidLabel.isHidden = false
                        self.testIsValidLabel.text = "✅ 사용 가능한 닉네임입니다."
                        self.testSignUpButton.backgroundColor = .customColor(.mainColor)
                        // TODO: 중복 확인 안하고 회원가입 버튼 눌렀을 경우 UI 디자인
                        self.testSignUpButton.isEnabled = true
                    }
                    
                case .failure(let error):
                    // TODO: 에러 처리 상세히 하기 - 인증정보 없음(토큰이 없는 경우(물론 여기 페이지까지 오면 토큰이 없는 경우는 없지만)에도 이미 존재하는 닉네임입니다로 뜸)
                    DispatchQueue.main.async {
                        self.testIsValidLabel.isHidden = false
                        self.testIsValidLabel.text = "❌이미 존재하는 닉네임입니다."
                    }
                    print("[SignUpVC] error: \(error.localizedDescription)")
                }
            }
        }
        // 닉네임을 입력하지 않은 경우
        // TODO: 아무것도 입력하지 않고 중복 확인 눌렀을 경우 UI 디자인
        else {
            DispatchQueue.main.async {
                self.testIsValidLabel.isHidden = false
                self.testIsValidLabel.text = "❌ 닉네임을 입력해주세요."
            }
            return
        }
    }
    
    private func postLoginToken() {
        let userSignUpInfo: [String: String] = [
            "nickname": testNickNameTextField.text!,    // TODO: 강제 언래핑 없애기
            "email": email,
            "provider": provider
        ]
        
        SignUpAPI.postLoginToken(params: userSignUpInfo) { result in
            switch result {
            case .success(let token):
                let token = token.accessToken
                KeychainManager.create(token: token)
                
                DispatchQueue.main.async {
                    // TODO: rootViewController 바꾸는 방법으로 전환
                    let tabBarController = TabBarController()
                    self.navigationController?.setViewControllers([tabBarController], animated: true)
                }
            
            case .failure(let error):
                // TODO: 에러 처리 상세하게
                print("[SignUpVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
