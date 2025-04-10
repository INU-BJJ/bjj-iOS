//
//  MyPageViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 닉네임을 자주 바꾸진 않으니까 닉네임만 조회하는 API 따로 요청?
        fetchMyPageInfo()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testMyNicknameLabel
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testMyNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyPageInfo() {
        MyPageAPI.fetchMyPageInfo() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let myPageInfo):
                DispatchQueue.main.async {
                    let nickname = myPageInfo.nickname
                    self.testMyNicknameLabel.text = "\(nickname)의 공간"
                }
                
            case .failure(let error):
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
