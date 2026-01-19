//
//  ItemProbabilityViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/19/26.
//

import UIKit
import SnapKit
import Then

final class ItemProbabilityViewController: BaseViewController {
    
    // MARK: - Components
    
    private let itemProbabilityImage = UIImageView().then {
        $0.setImage(.itemProbability)
        $0.setCornerRadius(radius: 10)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        view.addSubview(itemProbabilityImage)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        itemProbabilityImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(85)
            $0.centerX.equalToSuperview()
        }
    }
}
