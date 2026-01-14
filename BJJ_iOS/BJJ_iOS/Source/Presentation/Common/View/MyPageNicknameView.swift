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
            nicknameSpaceView
        ].forEach(addSubview)
        
        [
            nicknameLabel
        ].forEach(nicknameSpaceView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        nicknameSpaceView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
