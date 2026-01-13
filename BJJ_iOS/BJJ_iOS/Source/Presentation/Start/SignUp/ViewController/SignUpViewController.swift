//
//  SignUpViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/6/25.
//

import UIKit
import SnapKit
import Then

final class SignUpViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let email: String
    private let provider: String
    
    // MARK: - UI Components
    
    private let emailTitleLabel = UILabel().then {
        $0.setLabelUI("이메일", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private lazy var emailTextField = PaddingLabel(
        padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ).then {
        $0.setLabelUI(email, font: .pretendard, size: 13, color: .midGray)
        $0.setCornerRadius(radius: 3)
        $0.setBorder(color: .D_9_D_9_D_9)
        $0.backgroundColor = .F_6_F_6_F_8
    }
    
    private let nicknameTitleLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private let nicknameGuideLabel = UILabel().then {
        $0.setLabel("닉네임은 12글자까지 가능합니다.", font: .pretendard, size: 13, color: .B_9_B_9_B_9)
    }
    
    private let nicknameTextField = UITextField().then {
        $0.setTextField(placeholder: "닉네임", font: .pretendard, size: 13, leftPadding: 6)
    }
    
    private lazy var checkNicknameDupliCateButton = UIButton().then {
        $0.setButton(title: "중복 확인", font: .pretendard, size: 13, color: .black)
        $0.setBorder(color: .customColor(.mainColor))
        $0.setCornerRadius(radius: 27 / 2)
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
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("회원가입")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            emailTitleLabel,
            emailTextField,
            nicknameTitleLabel,
            nicknameGuideLabel,
            nicknameTextField,
            checkNicknameDupliCateButton,
            testIsValidLabel,
            testSignUpButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(33)
            $0.leading.equalTo(emailTitleLabel)
        }
        
        nicknameGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTitleLabel)
            $0.leading.equalTo(nicknameTitleLabel.snp.trailing).offset(12)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.centerY.equalTo(checkNicknameDupliCateButton)
            $0.leading.equalTo(nicknameTitleLabel)
            $0.trailing.equalTo(checkNicknameDupliCateButton.snp.leading).offset(-12)
            $0.height.equalTo(17)
        }
        
        checkNicknameDupliCateButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(77)
            $0.height.equalTo(27)
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
        postNickname(nickname: nicknameTextField.text)
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
            "nickname": nicknameTextField.text!,    // TODO: 강제 언래핑 없애기
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
