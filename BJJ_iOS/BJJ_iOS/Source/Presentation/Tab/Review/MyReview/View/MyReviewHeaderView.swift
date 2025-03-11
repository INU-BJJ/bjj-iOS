//
//  MyReviewHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

protocol MyReviewHeaderViewDelegate: AnyObject {
    func didTapReviewMoreButton(in section: Int)
}

final class MyReviewHeaderView: UITableViewHeaderFooterView, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: MyReviewHeaderViewDelegate?
    private var sectionIndex: Int = 0
    
    // MARK: - UI Components
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private lazy var reviewMoreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 11)
        $0.setTitleColor(.customColor(.darkGray), for: .normal)
        $0.addTarget(self, action: #selector(didTapReviewMoreButton), for: .touchUpInside)
    }
    
    // MARK: - Initializer
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            cafeteriaNameLabel,
            reviewMoreButton
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        cafeteriaNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(40)
        }
        
        reviewMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(cafeteriaNameLabel)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Configure HeaderView
    
    func configureMyReviewHeaderView(with cafeteriaName: String, section: Int) {
        cafeteriaNameLabel.text = cafeteriaName
        self.sectionIndex = section
    }
    
    func setReviewMoreButtonVisibility(_ isVisible: Bool) {
        reviewMoreButton.isHidden = !isVisible
    }
    
    // MARK: - Objc Function
    
    @objc private func didTapReviewMoreButton() {
        delegate?.didTapReviewMoreButton(in: sectionIndex)
    }
}
