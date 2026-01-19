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
    
    // MARK: - Components
    
    private let itemRarityLabel = PaddingLabel(
        padding: UIEdgeInsets(top: 2, left: 22, bottom: 2, right: 22)
    ).then {
        $0.backgroundColor = .white
        $0.setLabel("", font: .pretendard_semibold, size: 14, color: ._66280_C)
        $0.setCornerRadius(radius: 5)
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
            itemRarityLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        itemRarityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    func setUI(itemRarity: String) {
        itemRarityLabel.text = itemRarity
    }
}
