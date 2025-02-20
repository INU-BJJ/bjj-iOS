//
//  ReviewContentCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

final class ReviewContentCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let reviewContentLabel = UILabel().then {
        $0.setLabelUI("자세한 리뷰를 작성해주세요", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private let reviewTextView = UITextView().then {
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
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
            reviewContentLabel,
            reviewTextView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewContentLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(reviewContentLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(158)
        }
    }
}
