//
//  MenuHeaderCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/3/24.
//

import UIKit
import SnapKit
import Then

protocol MenuHeaderDelegate: AnyObject {
    func didTapMenuLikeButton()
}

final class MenuHeader: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: MenuHeaderDelegate?
    
    // MARK: - UI Components
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 24, color: .black)
    }
    
    private let menuFooterStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let menuPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 20, color: .black)
    }
    
    private lazy var menuLikeButton = UIButton().then {
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.masksToBounds = false
        $0.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
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
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            menuNameLabel,
            menuFooterStackView
        ].forEach(contentView.addSubview)
        
        [
            menuPriceLabel,
            menuLikeButton
        ].forEach(menuFooterStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(29)
        }
        
        menuFooterStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalTo(menuNameLabel)
            $0.height.greaterThanOrEqualTo(23)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuHeader(menuName: String, menuPrice: String) {
        menuNameLabel.text = menuName
        menuPriceLabel.text = menuPrice
    }
    
    // MARK: - Update MenuLikeButton
    
    func updateMenuLikeButton(isMemberLikedReview: Bool) {
        let heartIconName = isMemberLikedReview ? "BigHeart" : "EmptyBigHeart"
        let heartIcon = UIImage(named: heartIconName)
        
        menuLikeButton.setImage(heartIcon, for: .normal)
    }
    
    // MARK: - Objc Function
    
    @objc private func didTapLikeButton() {
        delegate?.didTapMenuLikeButton()
    }
}
