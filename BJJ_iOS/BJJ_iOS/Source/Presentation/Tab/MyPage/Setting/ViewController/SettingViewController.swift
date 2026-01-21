//
//  SettingViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import UIKit
import SnapKit
import Then

final class SettingViewController: BaseViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var editNicknameButton = UIButton().then {
        $0.setTitle("닉네임 변경하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(didTapEditNicknameButton), for: .touchUpInside)
    }
    
    private lazy var navigateLikedMenuVCButton = UIButton().then {
        $0.setTitle("좋아요한 메뉴", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(didTapGoToLikedMenuVCButton), for: .touchUpInside)
    }
    
    private lazy var blockedUserButton = UIButton().then {
        $0.setTitle("차단한 유저 보기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 15)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(didTapBlockedUserButton), for: .touchUpInside)
    }
    
    private let separatingView = UIView().then {
        $0.backgroundColor = .customColor(.backgroundGray)
    }
    
    private lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    private lazy var deleteAccountButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.contentHorizontalAlignment = .left
        $0.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("설정")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            editNicknameButton,
            navigateLikedMenuVCButton,
            blockedUserButton,
            separatingView,
            logoutButton,
            deleteAccountButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        editNicknameButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(18)
        }
        
        navigateLikedMenuVCButton.snp.makeConstraints {
            $0.top.equalTo(editNicknameButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(18)
        }
        
        blockedUserButton.snp.makeConstraints {
            $0.top.equalTo(navigateLikedMenuVCButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(18)
        }
        
        separatingView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(170)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(7)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(separatingView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(18)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(18)
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
    
    @objc private func didTapBlockedUserButton() {
        // TODO: 차단한 유저 목록 fetch
    }
    
    @objc private func didTapLogoutButton() {
        KeychainManager.delete(key: .accessToken)
        
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
                KeychainManager.delete(key: .accessToken)
                
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
