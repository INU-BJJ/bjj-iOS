//
//  PointView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import UIKit
import SnapKit
import Then

final class PointView: BaseView {
    
    // MARK: - Components
    
    private let pointImageView = UIImageView().then {
        $0.setImage(.point)
    }
    
    private let pointView = UIView().then {
        $0.backgroundColor = .white
        $0.setBorder(color: .customColor(.mainColor), width: 2)
        $0.setCornerRadius(radius: 23 / 2)
    }
    
    private let pointLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_semibold, size: 12, color: .black)
    }
    
    private let pointTextLabel = UILabel().then {
        $0.setLabel("p", font: .pretendard_semibold, size: 12, color: .black)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            pointView,
            pointImageView
        ].forEach(addSubview)
        
        [
            pointLabel,
            pointTextLabel
        ].forEach(pointView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        pointImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
        }
        
        pointView.snp.makeConstraints {
            $0.leading.equalTo(pointImageView).offset(7.26)
            $0.centerY.equalTo(pointImageView)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(23.45)
        }
        
        pointLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(33)
        }
        
        pointTextLabel.snp.makeConstraints {
            $0.leading.equalTo(pointLabel.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11.38)
        }
    }
    
    // MARK: - Configure
    
    func configurePointView(point: Int) {
        pointLabel.text = "\(point)"
    }
}
