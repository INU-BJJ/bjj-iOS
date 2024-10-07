//
//  HomeMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeMenuCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let menuHorizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuVerticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuInnerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuFooterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 103
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let menuPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .black)
    }
    
    // TODO: data에서 rating 받아와서 다시 넣기
    private let menuRatingView = HomeMenuRatingView(rating: 4.4)
    
    // TODO: 하트 아이콘 눌렀을 때, 아이콘 변경하기 (UIButton에서 makeHeartButton 함수 만들기)
    private let menuLikeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "EmptyHeart"), for: .normal)
    }
    
    private let cafeteriaLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 11, color: .black)
        $0.alpha = 0.5
    }

    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {
        self.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
    
    // MARK: - Configuration
    
    func configureCell() {
        
    }
}

