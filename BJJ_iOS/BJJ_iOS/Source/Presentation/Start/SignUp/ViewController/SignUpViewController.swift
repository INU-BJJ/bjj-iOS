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
    private let token: String
    
    // MARK: - UI Components
    
    private let testStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.alignment = .center
    }
    
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
    
    private let testNickNameTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.customColor(.midGray)
            ]
        )
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var testIsDupliCateButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(didTapDupplicateButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    init(email: String, token: String) {
        self.email = email
        self.token = token
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
            testStackView
        ].forEach(view.addSubview)
        
        [
            testEmailLabel,
            testEmailTextField,
            testNickNameLabel,
            testNickNameTextField,
            testIsDupliCateButton
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
    }
    
    // MARK: Objc Functions
    
    @objc private func didTapDupplicateButton() {
        
    }
}
