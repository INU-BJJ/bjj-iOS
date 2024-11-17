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
    
    private let menuView = UIView().then {
        $0.backgroundColor = .customColor(.subColor)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let menuLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.numberOfLines = 0
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
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(menuView)
        menuView.addSubview(menuLabel)
    }
    
    // MARK: - Set Constraints()
    
    private func setConstraints() {
        menuView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        menuLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-192)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuInfoCell(with menuCompositionItem: String) {
        menuLabel.text = menuCompositionItem
    }
}
