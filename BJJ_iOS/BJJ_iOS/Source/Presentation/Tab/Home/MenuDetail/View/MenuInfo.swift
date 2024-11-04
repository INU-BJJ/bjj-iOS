//
//  MenuInfoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuInfo: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuInfo"
//    private var menuItems: [MenuItem] = []
    
    // MARK: - UI Components
    
//    private let menuInfoCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: createLayout()
//    ).then {
//        $0.register(MenuInfoCell.self, forCellWithReuseIdentifier: MenuInfoCell.identifier)
//        $0.register(MenuInfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MenuInfoHeaderView.identifier)
//    }
    
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
        [
           
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
    
    // MARK: - Configure Cell
    
    func configure() {
        
    }
}
