//
//  MyPageViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/8/25.
//

import UIKit
import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let testMyNicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMemberInfo()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testMyNicknameLabel,
            testLogoutButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testMyNicknameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        testLogoutButton.snp.makeConstraints {
            $0.top.equalTo(testMyNicknameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMemberInfo() {
        MemberAPI.fetchMemberInfo() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let member):
                DispatchQueue.main.async {
                    let nickname = member.nickname
                    
                    self.testMyNicknameLabel.text = nickname
                }
                
            case .failure(let error):
                print("[MyPageVC] Fetching Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Objc Functions
    
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
