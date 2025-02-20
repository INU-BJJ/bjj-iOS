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
    
    private lazy var reviewTextView = UITextView().then {
        $0.setTextViewUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 17, bottom: 38, right: 36)
        $0.textContainer.lineFragmentPadding = 0
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
        $0.delegate = self
    }
    
    private let reviewTextViewPlaceholder = UILabel().then {
        $0.setLabelUI("텍스트 리뷰는 000P, 포토리뷰는 000P 드려요.", font: .pretendard_medium, size: 13, color: .midGray)
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
        
        [
            reviewTextViewPlaceholder
        ].forEach(reviewTextView.addSubview)
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
        
        reviewTextViewPlaceholder.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 16, left: 17, bottom: 38, right: 36))
        }
    }
}

extension ReviewContentCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reviewTextViewPlaceholder.isHidden = !reviewTextView.text.isEmpty
    }
}
