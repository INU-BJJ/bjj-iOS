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
    
    // TODO: 줄바꿈 많을 경우 글자수 인디케이터 부분까지 침범하게 됨. 추후 해결 과제
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
    
    private let characterLimitView = UIView()
    
    // TODO: 사용자 입력에 따라 동적으로 바꾸기
    private let currentCharacterLabel = UILabel().then {
        $0.setLabelUI("258 ", font: .pretendard, size: 13, color: .black)
    }
    
    private let characterLimitLabel = UILabel().then {
        $0.setLabelUI("/ 500", font: .pretendard, size: 13, color: .midGray)
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
            reviewTextViewPlaceholder,
            characterLimitView
        ].forEach(reviewTextView.addSubview)
        
        [
            currentCharacterLabel,
            characterLimitLabel
        ].forEach(characterLimitView.addSubview)
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
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(17)
        }
        
        // TODO: 양 옆 간격 다른 것 질문
        // TODO: 아래와 같이 코드를 작성하면 leading, trailing 값이 다름. 원인을 모르겠음. 추후 수정
        characterLimitView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.width.equalTo(316)
        }
        
        currentCharacterLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalTo(characterLimitLabel.snp.leading)
        }
        
        characterLimitLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview()
        }
    }
}

extension ReviewContentCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reviewTextViewPlaceholder.isHidden = !reviewTextView.text.isEmpty
    }
}
