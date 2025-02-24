//
//  MyReviewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
    }
    
    private let menuLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private let dateLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .darkGray)
    }
    
    private let ratingLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .black)
    }
    
    private let starIcon = UIImageView().then {
        $0.image = UIImage(named: "Star")
        $0.tintColor = .customColor(.mainColor)
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(containerView)
        
        [
            menuLabel,
            dateLabel,
            starIcon,
            ratingLabel
        ].forEach(containerView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 31, bottom: 10, right: 31))
        }
        
        menuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(9)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(menuLabel)
            $0.top.equalTo(menuLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalTo(dateLabel)
        }
        
        starIcon.snp.makeConstraints {
            $0.trailing.equalTo(ratingLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(dateLabel)
            $0.width.equalTo(12)
            $0.height.equalTo(11.2)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMyReviewCell(with myReview: MyReviewModel) {
        menuLabel.text = "\(myReview.mainMenuName) * \(myReview.subMenuName)"
        dateLabel.text = myReview.reviewCreatedDate
        ratingLabel.text = "\(myReview.reviewRating)"
    }
}
