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
        $0.setImage(.pointView)
    }
    
    private let pointLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_semibold, size: 12, color: .black)
    }
    
    // MARK: - Init
    
    init(point: Int) {
        super.init(frame: .zero)
        pointLabel.text = "\(point)"
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        addSubview(pointImageView)
        
        [
            pointLabel
        ].forEach(pointImageView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        pointImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
