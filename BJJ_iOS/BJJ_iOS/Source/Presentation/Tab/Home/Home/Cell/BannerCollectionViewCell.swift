//
//  BannerCollectionViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import UIKit
import SnapKit
import Then
import SDWebImage

final class BannerCollectionViewCell: BaseCollectionViewCell<Banner> {
    
    // MARK: - Components
    
    private let bannerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        contentView.addSubview(bannerImageView)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: Banner) {
        bannerImageView.sd_setImage(
            with: URL(string: baseURL.bannerImageURL + data.image),
            placeholderImage: nil,
            options: [.retryFailed, .continueInBackground]
        )
    }
}
