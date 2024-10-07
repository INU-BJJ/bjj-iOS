//
//  HomeMenuRatingView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeMenuRatingView: UIView {
    
    // MARK: Properties
    
    private let rating: Float
    
    // MARK: UI Components
    
    private let starIcon = UIImageView(image: UIImage(named: "star"))
    
    private let ratingLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .black)
    }
    
    // MARK: LifeCycle
        
    init(rating: Float) {
        self.rating = rating
        super.init(frame: .zero)
        
        setUI()
        setAddView()
        setConstraints()
        configureRatingLabel(with: rating)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
        
    private func setUI() {
        self.backgroundColor = .customColor(.subColor)
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
        // TODO: 왜 starIcon의 y값이 중앙이 아닌 위는3, 아래는 4? 그냥 center로 하면 안됨?
        starIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(15)
            $0.height.equalTo(14)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.centerX.equalTo(starIcon)
        }
    }
    
    // MARK: Other Fucntions
    
    private func configureRatingLabel(with rating: Float) {
        ratingLabel.text = "\(rating)"
    }
}
