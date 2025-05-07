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
    
    private lazy var testGoToLikedMenuVCButton = UIButton().then {
        $0.setTitle("좋아요한 메뉴", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(didTapGoToLikedMenuVCButton), for: .touchUpInside)
    }
    
    private lazy var testLogoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    private lazy var testDeleteAccountButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
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
            testGoToLikedMenuVCButton,
            testLogoutButton,
            testDeleteAccountButton
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
        
        testGoToLikedMenuVCButton.snp.makeConstraints {
            $0.top.equalTo(testEditNicknameButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        testLogoutButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        testDeleteAccountButton.snp.makeConstraints {
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
    
    @objc private func didTapGoToLikedMenuVCButton() {
        DispatchQueue.main.async {
            self.presentLikedMenuViewController()
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
    
    @objc private func didTapDeleteAccountButton() {
        MemberAPI.deleteMemberInfo { result in
            switch result {
            case .success:
                KeychainManager.delete()
                
                DispatchQueue.main.async {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes
                            .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate else {
                        return
                    }
                    // TODO: 회원 탈퇴 애니메이션 or 화면 추가
                    sceneDelegate.setRootViewController()
                }
            case .failure(let error):
                print("[SettingVC] Member Delete Error: \(error.localizedDescription)")
            }
        }
    }
}
