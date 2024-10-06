//
//  HomeCafeteriaCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeCafeteriaCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
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
