//
//  SignUpViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/6/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let signUpViewModel = SignUpViewModel()
    
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
    
    private let dividingLine = SeparatingLine(color: .F_6_F_6_F_8)
    
    private let consentTitleLabel = UILabel().then {
        $0.setLabel("약관 동의", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private lazy var consentCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(ConsentCollectionViewCell.self, forCellWithReuseIdentifier: ConsentCollectionViewCell.reuseIdentifier)
        $0.delegate = self
        $0.isScrollEnabled = false
    }
    
    private let consentSeparatingLine = SeparatingLine(color: .A_9_A_9_A_9)
    
    private let allAgreeIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(.bigEmptyBorderCheckBox)
    }
    
    private let allAgreeTitleLabel = UILabel().then {
        $0.setLabel("전체 동의", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private lazy var signUpButton = ConfirmButton(title: "밥점줘 시작하기")
    
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
            nicknameTextFieldBorder,
            checkNicknameDupliCateButton,
            validResultIcon,
            validResultLabel,
            dividingLine,
            consentTitleLabel,
            consentCollectionView,
            consentSeparatingLine,
            allAgreeIcon,
            allAgreeTitleLabel,
            signUpButton
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
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(checkNicknameDupliCateButton.snp.bottom).offset(245)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(7)
        }
        
        consentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dividingLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        consentCollectionView.snp.makeConstraints {
            $0.top.equalTo(consentTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(0) // 초기값, 데이터 바인딩 시 업데이트
        }
        
        consentSeparatingLine.snp.makeConstraints {
            $0.bottom.equalTo(allAgreeIcon.snp.top).offset(-12)
            $0.horizontalEdges.equalTo(consentCollectionView)
            $0.height.equalTo(1)
        }
        
        allAgreeIcon.snp.makeConstraints {
            $0.bottom.equalTo(signUpButton.snp.top).offset(-34)
            $0.leading.equalTo(signUpButton)
            $0.size.equalTo(24)
        }
        
        allAgreeTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(allAgreeIcon)
            $0.leading.equalTo(allAgreeIcon.snp.trailing).offset(12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(47)
        }
    }
    
    // MARK: - Bind

    override func bind() {
        let input = SignUpViewModel.Input()
        let output = signUpViewModel.transform(input: input)
        
        // 닉네임 글자수 12자 제한
        nicknameTextField.rx.text.orEmpty
            .map { text -> String in
                if text.count > 12 {
                    return String(text.prefix(12))
                }
                return text
            }
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 약관 동의 collectionView
        output.consentList
            .do(onNext: { [weak self] consentList in
                guard let self = self else { return }
                updateCollectionViewHeight(count: consentList.count)
            })
            .bind(to: consentCollectionView.rx.items(
                cellIdentifier: ConsentCollectionViewCell.reuseIdentifier,
                cellType: ConsentCollectionViewCell.self
            )) { index, consent, cell in
                cell.configureCell(with: consent)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12

        return layout
    }
    
    // MARK: - Update CollectionView Height
    
    private func updateCollectionViewHeight(count: Int) {
        let cellHeight: CGFloat = 20
        let spacing: CGFloat = 12
        let itemCount = count
        let totalHeight = CGFloat(itemCount) * cellHeight + CGFloat(max(0, itemCount - 1)) * spacing
        
        self.consentCollectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
    }
    
    // MARK: Objc Functions
    
    @objc private func didNicknameChange(_ textField: UITextField) {
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = .customColor(.midGray)
        validResultIcon.isHidden = true
        validResultLabel.isHidden = true
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
                        self.validResultIcon.isHidden = false
                        self.validResultLabel.isHidden = false
                        self.validResultIcon.setImage(.checkCircleGreen)
                        self.validResultLabel.text = "사용 가능한 닉네임입니다."
                        self.signUpButton.backgroundColor = .customColor(.mainColor)
                        // TODO: 중복 확인 안하고 회원가입 버튼 눌렀을 경우 UI 디자인
                        self.signUpButton.isEnabled = true
                    }
                    
                case .failure(let error):
                    // TODO: 에러 처리 상세히 하기 - 인증정보 없음(토큰이 없는 경우(물론 여기 페이지까지 오면 토큰이 없는 경우는 없지만)에도 이미 존재하는 닉네임입니다로 뜸)
                    DispatchQueue.main.async {
                        self.validResultIcon.isHidden = false
                        self.validResultLabel.isHidden = false
                        self.validResultIcon.setImage(.checkCircleWarning)
                        self.validResultLabel.text = "이미 존재하는 닉네임입니다."
                    }
                    print("[SignUpVC] error: \(error.localizedDescription)")
                }
            }
        }
        // 닉네임을 입력하지 않은 경우
        // TODO: 아무것도 입력하지 않고 중복 확인 눌렀을 경우 UI 디자인
        else {
            DispatchQueue.main.async {
                self.validResultIcon.isHidden = false
                self.validResultLabel.isHidden = false
                self.validResultIcon.setImage(.checkCircleWarning)
                self.validResultLabel.text = "닉네임을 입력해주세요."
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

// MARK: - UICollectionView Delegate FlowLayout

extension SignUpViewController: UICollectionViewDelegateFlowLayout {
    
    // cell 사이즈
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
}
