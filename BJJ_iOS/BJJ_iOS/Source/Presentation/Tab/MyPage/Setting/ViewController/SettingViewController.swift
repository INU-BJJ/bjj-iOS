//
//  SettingViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = SettingViewModel()
    
    // MARK: - UI Components
    
    // TODO: UICollectionView + List Configuration
    private let settingTableView = UITableView().then {
        $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        $0.separatorStyle = .none
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
            settingTableView,
            separatingView,
            logoutButton,
            deleteAccountButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        settingTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(106)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(separatingView.snp.top)
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
    
    // MARK: - Bind
    
    override func bind() {
        let input = SettingViewModel.Input()
        let output = viewModel.transform(input: input)
        
        // 설정 메뉴
        output.settingList
            .bind(to: settingTableView.rx.items(
                cellIdentifier: SettingTableViewCell.reuseIdentifier,
                cellType: SettingTableViewCell.self)
            ) { index, setting, cell in
                cell.configureCell(with: setting)
            }
            .disposed(by: disposeBag)
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
