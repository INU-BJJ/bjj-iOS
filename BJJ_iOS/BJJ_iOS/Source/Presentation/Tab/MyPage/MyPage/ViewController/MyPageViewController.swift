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
    
    private var myPageViewData: MyPageSection?
    
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
    
    // MARK: - Set UI
    
    private func setUI() {
        DispatchQueue.main.async {
            self.testMyNicknameLabel.text = "\(self.myPageViewData?.nickname ?? "")의 공간"
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyPageInfo() {
        MyPageAPI.fetchMyPageInfo() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let myPageInfo):
                // self.myPageViewData = MyPageSection()과 같은 의미
                myPageViewData = MyPageSection(
                    nickname: myPageInfo.nickname,
                    characterID: myPageInfo.characterID,
                    characterImage: myPageInfo.characterImage,
                    backgroundID: myPageInfo.backgroundID,
                    backgroundImage: myPageInfo.backgroundImage
                )
                setUI()
                
            case .failure(let error):
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
