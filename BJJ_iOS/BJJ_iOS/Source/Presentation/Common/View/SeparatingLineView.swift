//
//  SeparatingLineView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class SeparatingLineView: UIView {
    
    // MARK: - Properties
    
    private var dividingColor: UIColor
    
    // MARK: Life Cycle
    
    init(color: UIColor) {
        self.dividingColor = color
        super.init(frame: .zero)
        
        setUI()
    }
    
    init(frame: CGRect, color: UIColor) {
        self.dividingColor = color
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = dividingColor
    }
}
