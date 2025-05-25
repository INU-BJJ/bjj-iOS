//
//  MenuReviewListCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 5/24/25.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let reviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .leading
    }
    
    private let menuReviewInfoView = MenuReviewInfoView()
    
    private let reviewCommentLabel = UILabel().then {
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
        [
            reviewStackView
        ].forEach(contentView.addSubview)
        
        [
            menuReviewInfoView,
            reviewCommentLabel,
//            reviewImageCollectionView,
//            reviewHashTagCollectionView
        ].forEach(reviewStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(400)
        }
        
        menuReviewInfoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(41)
        }
    }
    
    // MARK: - Configure Cell
    
    func configure(with menuReview: MenuDetailModel) {
        menuReviewInfoView.setUI(with: menuReview)
        reviewCommentLabel.text = menuReview.reviewComment
    }
}
