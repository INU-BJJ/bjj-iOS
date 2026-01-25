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
    
    lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
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
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 182)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
}
