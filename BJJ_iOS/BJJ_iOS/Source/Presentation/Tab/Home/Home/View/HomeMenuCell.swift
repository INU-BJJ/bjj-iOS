//
//  HomeMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HomeMenuCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let menuStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
        $0.layer.masksToBounds = true
    }
    
    private let menuRightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
        $0.distribution = .fill
        $0.alignment = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2.62, leading: .zero, bottom: 2.62, trailing: .zero)
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
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: .zero, leading: 5, bottom: .zero, trailing: .zero)
    }
    
    private let menuFooterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let menuImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let menuPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
    }
    
    private let menuRatingView = MenuRatingView()
    
    private let menuLikedImageView = UIImageView()
    
    private let cafeteriaLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 11, color: .black)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow()
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
         menuLikedImageView
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
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6.38, left: 10, bottom: 6.38, right: 10))
        }
        
        menuImageView.snp.makeConstraints {
            $0.width.equalTo(97)
        }

        menuFooterStackView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(21)
        }
        
        menuLikedImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        menuRatingView.snp.makeConstraints {
            $0.width.equalTo(53)
        }
    }
    
    // MARK: - Configuration
    
    func configureCell(menuName: String, menuPrice: String, imageName: String, cafeteriaName: String, cafeteriaCorner: String, menuRating: Double, isLikedMenu: Bool) {
        menuNameLabel.text = menuName
        menuPriceLabel.text = menuPrice
        if imageName == "DefaultMenuImage" {
            menuImageView.image = UIImage(named: "HomeDefaultMenuImage")
        } else {
            menuImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(imageName)"))
        }
        cafeteriaLabel.text = "\(cafeteriaName) \(cafeteriaCorner)"
        menuRatingView.configureRatingLabel(with: menuRating)
        menuLikedImageView.image = UIImage(named: isLikedMenu ? "Heart" : "EmptyHeart")
    }
    
    // MARK: - Set Shadow
    
    private func setShadow() {
        self.clipsToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 3).cgPath
        self.layer.shadowColor = UIColor(red: 0.047, green: 0.047, blue: 0.051, alpha: 0.05).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: .zero, height: 1)
    }
}

