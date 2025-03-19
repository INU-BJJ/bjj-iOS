//
//  HomeMenuRatingView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class MenuRatingView: UIView {
    
    // MARK: Properties
    
    // MARK: UI Components
    
    private let starIcon = UIImageView(image: UIImage(named: "Star"))
    
    private let ratingLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
    }
    
    // MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
        
    private func setUI() {
        backgroundColor = .customColor(.subColor)
        layer.cornerRadius = 21 / 2
        clipsToBounds = true
    }
    
    // MARK: Set AddViews
    
    private func setAddView() {
        [
         starIcon,
         ratingLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        starIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalTo(starIcon.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: Other Fucntions
    
    func configureRatingLabel(with rating: Double) {
        ratingLabel.text = "\(rating)"
    }
}
