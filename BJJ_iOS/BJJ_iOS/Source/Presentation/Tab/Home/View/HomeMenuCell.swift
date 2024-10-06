//
//  HomeMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeMenuCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let menuImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let menuPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .black)
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
    
    // MARK: - Set UI
        
    private func setUI() {
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
    
    // MARK: - Configuration
    
    func configureCell() {
        
    }
}

