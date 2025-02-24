//
//  ReviewRatingCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/10/25.
//

import UIKit
import SnapKit
import Then
import Cosmos

final class ReviewRatingCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let reviewRatingLabel = UILabel().then {
        $0.setLabelUI("음식 만족도를 평가해주세요", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private let reviewRatingView = CosmosView().then {
        $0.settings.filledImage = UIImage(named: "BigStar")
        $0.settings.emptyImage = UIImage(named: "EmptyBigStar")
        // TODO: 별 사이즈 커스텀 (34.58 x 32.27)로 리사이징
        $0.settings.starSize = 34.58
        $0.settings.starMargin = 11.53
        $0.rating = 0
        $0.settings.updateOnTouch = true
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
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            reviewRatingLabel,
            reviewRatingView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewRatingLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        reviewRatingView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
    }
}
