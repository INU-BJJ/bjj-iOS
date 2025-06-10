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

final class ReviewPhotoCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let reviewPhotoImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(reviewPhotoImageView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewPhotoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    func setUI(reviewPhoto: String) {
        reviewPhotoImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(reviewPhoto)"))
    }
}
