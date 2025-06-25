//
//  ReviewContentCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

protocol ReviewContentDelegate: AnyObject {
    func didChangeReviewText(_ text: String)
}

final class ReviewContentCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: ReviewContentDelegate?
    
    // MARK: - UI Components
    
    private let reviewContentLabel = UILabel().then {
        $0.setLabelUI("자세한 리뷰를 작성해주세요", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private let reviewTextViewBorder = UIView().then {
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    private lazy var reviewTextView = UITextView().then {
        $0.setTextViewUI("", font: .pretendard_medium, size: 13, color: .black)
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        $0.textContainer.lineFragmentPadding = 0
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    private let reviewTextViewPlaceholder = UILabel().then {
        $0.setLabelUI("텍스트 리뷰는 000P, 포토리뷰는 000P 드려요.", font: .pretendard_medium, size: 13, color: .midGray)
    }
    
    private let characterLimitView = UIView()
    
    private let currentCharacterLabel = UILabel().then {
        $0.setLabelUI("0 ", font: .pretendard, size: 13, color: .midGray)
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
        addKeyboardToolbar()
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
            reviewTextViewBorder
        ].forEach(addSubview)
        
        [
            reviewTextView,
            characterLimitView
        ].forEach(reviewTextViewBorder.addSubview)
        
        [
            reviewTextViewPlaceholder
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
        
        reviewTextViewBorder.snp.makeConstraints {
            $0.top.equalTo(reviewContentLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(158)
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(38)
        }
        
        reviewTextViewPlaceholder.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        // TODO: 양 옆 간격 다른 것 질문
        // TODO: $0.horizontalEdges.equalToSuperView().inset(17)로 작성하면 leading, trailing 값이 다름. 원인을 모르겠음. 추후 수정
        characterLimitView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        currentCharacterLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalTo(characterLimitLabel.snp.leading)
        }
        
        characterLimitLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Get Review Text
    
    func getReviewText() -> String {
        return reviewTextView.text ?? ""
    }
}

extension ReviewContentCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            var characterCount = textView.text.count
                    
            let maxCharacterCount = 500
            if characterCount > maxCharacterCount {
                textView.text = String(textView.text.prefix(maxCharacterCount))
                characterCount = maxCharacterCount
            }
            
            self.currentCharacterLabel.textColor = characterCount > 0 ? .customColor(.black) : .customColor(.midGray)
            self.currentCharacterLabel.text = "\(characterCount) "
            self.reviewTextViewPlaceholder.isHidden = !self.reviewTextView.text.isEmpty
            self.delegate?.didChangeReviewText(self.reviewTextView.text)
        }
    }
}

extension ReviewContentCell {
    
    // MARK: - Dismiss Keyboard
    
    // TODO: 다른 방법도 고민해보기
    // TODO: [UIKeyboardTaskQueue lockWhenReadyForMainThread] timeout waiting for task on queue 해결하기
    // TODO: 키보드에 textView가 가려지는 문제 해결하기
    
    private func addKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let marginSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.dismissKeyboardWithToolbar))
        toolbar.items = [marginSpace, doneButton]
        
        self.reviewTextView.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboardWithToolbar() {
//        self.reviewTextView.inputAccessoryView = nil
        self.reviewTextView.resignFirstResponder()
    }
}
