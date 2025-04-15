//
//  SettingViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import UIKit
import SnapKit
import Then

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var testEditNicknameButton = UIButton().then {
        $0.setTitle("닉네임 변경하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(didTapEditNicknameButton), for: .touchUpInside)
    }
    
    private lazy var testLogoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
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
            testEditNicknameButton,
            testLogoutButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testEditNicknameButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        testLogoutButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapEditNicknameButton() {
        DispatchQueue.main.async {
            self.presentNicknameEditViewController()
        }
    }
    
    @objc private func didTapLogoutButton() {
        KeychainManager.delete()
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate else {
            return
        }

        DispatchQueue.main.async {
            // TODO: 로그아웃 전환 애니메이션 추가
            sceneDelegate.setRootViewController()
        }
    }
}
