//
//  MyPageNicknameView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import UIKit
import SnapKit
import Then

final class MyPageNicknameView: BaseView {
    
    // MARK: - Components
    
    private let leftColumnView = UIView().then {
        $0.backgroundColor = .customColor(.mainColor)
    }
    
    private let rightColumnView = UIView().then {
        $0.backgroundColor = .customColor(.mainColor)
    }
    
    private let nicknameSpaceView = UIView().then {
        $0.backgroundColor = .white
        $0.setBorder(color: .customColor(.mainColor), width: 2)
        $0.setCornerRadius(radius: 17)
    }
    
    private let nicknameLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_bold, size: 16, color: .black)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            leftColumnView,
            rightColumnView,
            nicknameSpaceView
        ].forEach(addSubview)
        
        [
            nicknameLabel
        ].forEach(nicknameSpaceView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        leftColumnView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(nicknameSpaceView.snp.centerX).offset(-15)
            $0.width.equalTo(9)
            $0.height.equalTo(22)
        }
        
        rightColumnView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(nicknameSpaceView.snp.centerX).offset(15)
            $0.size.equalTo(leftColumnView)
        }
        
        nicknameSpaceView.snp.makeConstraints {
            $0.top.equalTo(leftColumnView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
    }
    
    // MARK: - Configure
    
    func configureNickname(nickname: String) {
        nicknameLabel.text = nickname
    }
}
