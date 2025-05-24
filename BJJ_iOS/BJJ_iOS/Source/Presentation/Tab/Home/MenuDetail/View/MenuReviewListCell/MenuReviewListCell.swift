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
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    private let reviewCommentLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
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
            reviewCommentLabel
        ].forEach(reviewStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(300)
        }
    }
    
    // MARK: - Configure Cell
    
    func configure(text: String) {
        reviewCommentLabel.text = text
    }
}
