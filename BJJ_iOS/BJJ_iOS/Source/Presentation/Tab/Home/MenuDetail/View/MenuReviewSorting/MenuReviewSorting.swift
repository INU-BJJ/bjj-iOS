//
//  MenuReviewFooterView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

protocol MenuReviewSortingDelegate: AnyObject {
    func didTapOnlyPhotoReview(isTapped: Bool)
}

final class MenuReviewSorting: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: MenuReviewSortingDelegate?
    private var isChecked = false
    
    // MARK: - UI Components

    private lazy var onlyPhotoReviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnlyPhotoCheckBox)))
    }
    
    private let onlyPhotoReviewCheckBox = UIImageView().then {
        $0.image = UIImage(named: "checkBox")
    }
    
    private let onlyPhotoReviewLabel = UILabel().then {
        $0.setLabelUI("포토 리뷰만", font: .pretendard_medium, size: 13, color: .darkGray)
    }
    
    private let reviewToggleButton = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
    }
    
    private let toggleLabel = UILabel().then {
        $0.setLabelUI("메뉴일치순", font: .pretendard_medium, size: 13, color: .black)
    }
    
    private let toggleImage = UIImageView().then {
        $0.image = UIImage(named: "toggle")
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            onlyPhotoReviewStackView,
            reviewToggleButton
        ].forEach(addSubview)
        
        [
            onlyPhotoReviewCheckBox,
            onlyPhotoReviewLabel
        ].forEach(onlyPhotoReviewStackView.addArrangedSubview)
        
        [
            toggleLabel,
            toggleImage
        ].forEach(reviewToggleButton.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        onlyPhotoReviewStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(22)
        }
        
        reviewToggleButton.snp.makeConstraints {
            $0.centerY.equalTo(onlyPhotoReviewStackView)
            $0.trailing.equalToSuperview().offset(-22)
        }
    }
    
    // MARK: - Objc Function
    
    @objc private func didTapOnlyPhotoCheckBox() {
        isChecked.toggle()
        let checkBox = isChecked ? "CheckedBox" : "checkBox"
        onlyPhotoReviewCheckBox.image = UIImage(named: checkBox)
        delegate?.didTapOnlyPhotoReview(isTapped: isChecked)
    }
}
