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
        $0.spacing = 4
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
    
    func configureReviewStar(reviewRating: Int) {
        for _ in 0..<reviewRating {
            let filledStarIcon = UIImageView(image: UIImage(named: "Star")?.resize(to: CGSize(width: 12.0, height: 11.2)))
            filledStarIcon.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(filledStarIcon)
        }
        
        for _ in 0..<5 - reviewRating {
            let emptyStarIcon = UIImageView(image: UIImage(named: "EmptyStar")?.resize(to: CGSize(width: 12.0, height: 11.2)))
            emptyStarIcon.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(emptyStarIcon)
        }
    }
}
