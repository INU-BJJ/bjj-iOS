//
//  ItemSectionHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 5/29/25.
//

import UIKit
import SnapKit
import Then

final class ItemSectionHeaderView: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let testItemRarityBackgroundView = UIView().then {
        $0.backgroundColor = .customColor(.subColor)
    }
    
    private let testItemRarityLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            testItemRarityBackgroundView
        ].forEach(addSubview)
        
        [
            testItemRarityLabel
        ].forEach(testItemRarityBackgroundView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testItemRarityBackgroundView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(130)
        }
        
        testItemRarityLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    func setUI(itemRarity: String) {
        testItemRarityLabel.text = itemRarity
    }
}
