//
//  BaseView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setConstraints()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    func setUI() { }
    
    // MARK: - Set Hierarchy
    
    func setHierarchy() { }
    
    // MARK: - Set Constraints
    
    func setConstraints() { }
    
    // MARK: - Bind
    
    func bind() { }
}
