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
    
    // TODO: identifier 삭제
    
    static let identifier = "HomeMenuCell"
    
    // MARK: - UI Components
    
    private let menuStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
    }
    
    private let menuRightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let menuHeaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .top
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private let menuInnerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let menuFooterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let menuImageView = UIImageView().then {
        $0.image = UIImage(named: "MenuImage")
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
    private let menuRatingView = HomeMenuRatingView(rating: 4.4).then {
        // TODO: cornerRadius 조정
        $0.layer.cornerRadius = 0
        $0.clipsToBounds = true
    }
    
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
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(menuStackView)
        
        [
         menuImageView,
         menuRightStackView
        ].forEach(menuStackView.addArrangedSubview)
        
        [
         menuHeaderStackView,
         menuFooterStackView
        ].forEach(menuRightStackView.addArrangedSubview)
        
        [
         menuInnerStackView,
         menuLikeButton
        ].forEach(menuHeaderStackView.addArrangedSubview)
        
        [
         menuNameLabel,
         menuPriceLabel
        ].forEach(menuInnerStackView.addArrangedSubview)
        
        [
         menuRatingView,
         cafeteriaLabel
        ].forEach(menuFooterStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuStackView.snp.makeConstraints {
            // TODO: menuImageView와 menuRightStackView의 vertical inset 차이나니까 나중에 바꾸기
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6.38, left: 10, bottom: 6.38, right: 10))
        }
        
        menuImageView.snp.makeConstraints {
            $0.width.equalTo(97)
        }

        menuFooterStackView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(21)
        }
        
        menuLikeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        menuRatingView.snp.makeConstraints {
            $0.width.equalTo(53)
        }
    }
    
    // MARK: - Configuration
    
    func configureCell(menuName: String, menuPrice: String, imageName image: String, cafeteria: String) {
        menuNameLabel.text = menuName
        menuPriceLabel.text = menuPrice
        menuImageView.image = UIImage(named: image)
        cafeteriaLabel.text = cafeteria
    }
}

