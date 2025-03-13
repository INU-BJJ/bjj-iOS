//
//  MenuRankingCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/13/25.
//

import UIKit
import SnapKit
import Then

final class MenuRankingCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
    
    // MARK: - Configure Cell
    
}
