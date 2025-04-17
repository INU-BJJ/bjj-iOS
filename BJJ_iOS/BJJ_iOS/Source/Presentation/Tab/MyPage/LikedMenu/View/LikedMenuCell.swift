//
//  LikedMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then

final class LikedMenuCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let testMenuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
    }
    
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
            testMenuNameLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testMenuNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Set Cell UI
    
    func setCellUI(with likedMenu: LikedMenuSection) {
        testMenuNameLabel.text = likedMenu.menuName
    }
}
