//
//  ReviewPhotoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/10/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ReviewPhotoCell: BaseCollectionViewCell<String> {
    
    // MARK: - UI Components
    
    private let reviewPhotoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        contentView.addSubview(reviewPhotoImageView)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        reviewPhotoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: String) {
        reviewPhotoImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(data)"))
    }
}
