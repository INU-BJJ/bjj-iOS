//
//  MenuReviewListContent.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewListContent: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MenuReviewListContent"
    
    // MARK: - UI Components
    
    private let reviewContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 12
    }
    
    private let reviewContentTextView = UITextView().then {
        $0.textColor = .black
        $0.font = .customFont(.pretendard_medium, 13)
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets.zero
        $0.textContainer.lineFragmentPadding = 0
    }
    
    private let reviewImage = UIImageView().then {
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
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
            reviewContentTextView,
            reviewImage
        ].forEach(reviewContentStackView.addArrangedSubview)
        
        contentView.addSubview(reviewContentStackView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewContentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reviewImage.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureReviewListContent(with reviewList: MenuReviewInfo) {
        reviewContentTextView.text = reviewList.reviewContent
        reviewImage.image = UIImage(named: reviewList.reviewImage)
    }
}
