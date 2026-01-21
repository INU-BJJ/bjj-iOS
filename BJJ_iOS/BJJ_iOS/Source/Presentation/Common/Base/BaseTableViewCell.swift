//
//  BaseTableViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/21/26.
//

import UIKit

class BaseTableViewCell<T>: UITableViewCell, ReuseIdentifying {

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
