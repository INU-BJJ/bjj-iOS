//
//  BaseCollectionViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import UIKit

class BaseCollectionViewCell<T>: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setHierarchy()
        setConstraints()
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
    
    // MARK: - Configure Cell
    
    func configureCell(with data: T) { }
}
