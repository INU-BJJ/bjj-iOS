//
//  ItemTypeCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import UIKit
import SnapKit
import Then

final class ItemTypeCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let testItemNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
    }
    
    // MARK: - LifeCycle
        
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
            testItemNameLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testItemNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    func setUI(itemInfo: StoreSection) {
        DispatchQueue.main.async {
            self.testItemNameLabel.text = itemInfo.itemName
        }
    }
}
