//
//  MenuInfoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuInfoItemCell"
    
    // MARK: - UI Components
    
    private let menuLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        contentView.backgroundColor = .customColor(.subColor)
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(menuLabel)
    }
    
    // MARK: - Set Constraints()
    
    private func setConstraints() {
        menuLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuInfoCell(with text: String) {
        menuLabel.text = text
    }
}
