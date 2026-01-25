//
//  HomeTopView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeTopView: BaseView {
    
    // MARK: - Components
    
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            bannerCollectionView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        bannerCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        return layout
    }
}
