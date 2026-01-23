//
//  NicknameEditViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class NicknameEditViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = NicknameEditViewModel()
    
    // MARK: - UI Components
    
    private let nicknameTitleLabel = UILabel().then {
        $0.setLabelUI("닉네임", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private let nicknameGuideLabel = UILabel().then {
        $0.setLabel("닉네임은 12글자까지 가능합니다.", font: .pretendard, size: 13, color: .B_9_B_9_B_9)
    }
    
    private let nicknameTextField = UITextField().then {
        $0.setTextField(placeholder: "닉네임", font: .pretendard, size: 13, leftPadding: 6)
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    private let nicknameTextFieldBorder = SeparatingLine()
    
    private lazy var checkNicknameDupliCateButton = UIButton().then {
        $0.setButton(title: "중복 확인", font: .pretendard, size: 13, color: .black)
        $0.setBorder(color: .customColor(.mainColor))
        $0.setCornerRadius(radius: 27 / 2)
    }
    
    private let validResultIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
    }
    
    private let validResultLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 11, color: .black)
        $0.isHidden = true
    }
    
    private let editNicknameButton = ConfirmButton(title: "닉네임 변경하기")
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("닉네임 변경하기")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            nicknameTitleLabel,
            nicknameGuideLabel,
            nicknameTextField,
            nicknameTextFieldBorder,
            checkNicknameDupliCateButton,
            validResultIcon,
            validResultLabel,
            editNicknameButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(20)
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
        
        nicknameTextFieldBorder.snp.makeConstraints {
            $0.bottom.equalTo(checkNicknameDupliCateButton)
            $0.leading.equalTo(nicknameTextField)
            $0.trailing.equalTo(checkNicknameDupliCateButton.snp.leading).offset(-6)
            $0.height.equalTo(1)
        }
        
        checkNicknameDupliCateButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(7)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(77)
            $0.height.equalTo(27)
        }
        
        validResultIcon.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldBorder.snp.bottom).offset(8)
            $0.leading.equalTo(nicknameTextFieldBorder)
            $0.size.equalTo(17)
        }
        
        validResultLabel.snp.makeConstraints {
            $0.centerY.equalTo(validResultIcon)
            $0.leading.equalTo(validResultIcon.snp.trailing).offset(6)
        }
        
        editNicknameButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(47)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        // Input 생성
        let nicknameRelay = BehaviorRelay<String>(value: "")
        let checkDuplicateRelay = PublishRelay<String>()
        
        let input = NicknameEditViewModel.Input(
            checkNicknameDuplicate: checkDuplicateRelay,
            nickname: nicknameRelay,
//            signUpButtonTapped: signUpButtonTappedRelay
        )
        let output = viewModel.transform(input: input)
        
        // 닉네임 글자수 12자 제한 및 Input으로 전달
        nicknameTextField.rx.text.orEmpty
            .map { text -> String in
                if text.count > 12 {
                    return String(text.prefix(12))
                }
                return text
            }
            .do(onNext: { text in
                nicknameRelay.accept(text)
            })
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)

        // 중복 확인 버튼 탭 -> Input으로 전달
        checkNicknameDupliCateButton.rx.tap
            .withLatestFrom(nicknameTextField.rx.text.orEmpty)
            .bind(to: checkDuplicateRelay)
            .disposed(by: disposeBag)
        
        // 닉네임 검증 결과 -> UI 업데이트
        output.nicknameValidationResult
            .drive(with: self, onNext: { owner, state in
                switch state {
                case .idle:
                    owner.validResultIcon.isHidden = true
                    owner.validResultLabel.isHidden = true

                case .loading:
                    // 로딩 상태 처리 (필요시 추가)
                    break

                case .available:
                    owner.validResultIcon.isHidden = false
                    owner.validResultLabel.isHidden = false
                    owner.validResultIcon.setImage(.checkCircleGreen)
                    owner.validResultLabel.text = "사용 가능한 닉네임입니다."

                case .duplicate:
                    owner.validResultIcon.isHidden = false
                    owner.validResultLabel.isHidden = false
                    owner.validResultIcon.setImage(.checkCircleWarning)
                    owner.validResultLabel.text = "이미 존재하는 닉네임입니다."

                case .empty:
                    owner.validResultIcon.isHidden = false
                    owner.validResultLabel.isHidden = false
                    owner.validResultIcon.setImage(.checkCircleWarning)
                    owner.validResultLabel.text = "닉네임을 입력해주세요."
                }
            })
            .disposed(by: disposeBag)

//        // 회원가입 버튼 활성화 여부
//        output.signUpButtonEnabled
//            .drive(with: self, onNext: { owner, isEnabled in
//                owner.signUpButton.setUI(isEnabled: isEnabled)
//            })
//            .disposed(by: disposeBag)

//        // 회원가입 결과 처리
//        output.signUpResult
//            .drive(with: self, onNext: { owner, result in
//                switch result {
//                case .success(let accessToken):
//                    // 토큰 저장
//                    KeychainManager.create(value: accessToken, key: .accessToken)
//                    KeychainManager.delete(key: .tempToken)
//                    
//                    // TabBarController로 화면 전환
//                    DispatchQueue.main.async {
//                        let tabBarController = TabBarController()
//                        owner.navigationController?.setViewControllers([tabBarController], animated: true)
//                    }
//
//                case .failure:
//                    owner.presentAlertViewController(alertType: .failure, title: "회원가입에 실패했습니다.\n다시 시도해주세요.")
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
