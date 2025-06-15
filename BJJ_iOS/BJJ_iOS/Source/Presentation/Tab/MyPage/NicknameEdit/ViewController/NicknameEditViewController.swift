//
//  NicknameEditViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then

final class NicknameEditViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let testStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .center
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
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var testEditNicknameButton = UIButton().then {
        $0.setTitle("닉네임 변경하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.midGray)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapEditNicknameButton), for: .touchUpInside)
    }
    
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
            testStackView
        ].forEach(view.addSubview)
        
        [
            testNickNameLabel,
            testNickNameTextField,
            testIsDupliCateButton,
            testIsValidLabel,
            testEditNicknameButton
        ].forEach(testStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        testIsDupliCateButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        testEditNicknameButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: Objc Functions
    
    @objc private func didNicknameChange(_ textField: UITextField) {
        testEditNicknameButton.isEnabled = false
        testEditNicknameButton.backgroundColor = .customColor(.midGray)
        testIsValidLabel.isHidden = true
    }
    
    @objc private func didTapDupplicateButton() {
        postNickname(nickname: testNickNameTextField.text)
    }
    
    @objc private func didTapEditNicknameButton() {
        patchNickname(nickname: testNickNameTextField.text)
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
                        self.testEditNicknameButton.backgroundColor = .customColor(.mainColor)
                        // TODO: 중복 확인 안하고 회원가입 버튼 눌렀을 경우 UI 디자인
                        self.testEditNicknameButton.isEnabled = true
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
    
    // MARK: - Patch API Functions
    
    private func patchNickname(nickname: String?) {
        if let nickname = nickname, !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            SettingAPI.patchNickname(nickname: nickname) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.presentAlertViewController(alertType: .success(.nicknameEdit)) { [weak self] in
                                if let self = self {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    print("[NicknameEditVC] patchNickname: self 옵셔널 바인딩 실패")
                                }
                            }
                        }
                        
                    case .failure(let error):
                        self.presentAlertViewController(alertType: .failure(.nicknameEdit))
                        print("[NicknameEditVC] Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
