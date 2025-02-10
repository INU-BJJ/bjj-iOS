//
//  ReviewHorizontalView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class ReviewHorizontalView: UIView {
    
    // MARK: - Properties
    
//    private let rating: Int
    
    // MARK: - UI Components
    
    private let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    // MARK: - LifeCycle
        
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
        self.backgroundColor = .clear
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            starStackView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        starStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Star
    
    func configureReviewStar(reviewRating: Int, type: StarSizeType) {
        starStackView.spacing = type.stackViewSpacing
        // TODO: 삭제 고려
//        starStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 0..<reviewRating {
            let filledStarIcon = UIImageView(image: type.filledStarImage?.resize(to: type.starSize))
            filledStarIcon.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(filledStarIcon)
        }
        
        for _ in 0..<5 - reviewRating {
            let emptyStarIcon = UIImageView(image: type.emptyStarImage?.resize(to: type.starSize))
            emptyStarIcon.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(emptyStarIcon)
        }
    }
}
