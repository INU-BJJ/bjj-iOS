//
//  MenuTopRankingCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/13/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class MenuTopRankingCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let menuTopRankingCellView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    
    private let medalIcon = UIImageView()
    
    private let menuImageView = UIImageView().then {
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
    }
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let menuRatingStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let menuRatingLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .mainColor)
        $0.setLineSpacing(kernValue: 0.13, lineHeightMultiple: 1.01)
    }
    
    private let menuMaxRatingLabel = UILabel().then {
        $0.setLabelUI("/ 10", font: .pretendard_medium, size: 13, color: .darkGray)
    }
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 11, color: .darkGray)
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow(to: menuTopRankingCellView)
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        contentView.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(menuTopRankingCellView)
        
        [
            medalIcon,
            menuImageView,
            menuNameLabel,
            menuRatingStackView,
            cafeteriaNameLabel
        ].forEach(menuTopRankingCellView.addSubview)

        [
            menuRatingLabel,
            menuMaxRatingLabel
        ].forEach(menuRatingStackView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuTopRankingCellView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 13, right: 0))
        }
        
        medalIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8.08)
            $0.centerY.equalToSuperview()
        }
        
        menuImageView.snp.makeConstraints {
            // TODO: 질문) 1등 cell만 13.08로 되어 있음
            $0.leading.equalTo(medalIcon.snp.trailing).offset(14.08)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(71)
            $0.height.equalTo(53)
        }
        
        menuNameLabel.snp.makeConstraints {
            $0.leading.equalTo(menuImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(13)
        }
        
        menuRatingStackView.snp.makeConstraints {
            $0.top.equalTo(menuNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(menuNameLabel)
            $0.width.equalTo(53)
            $0.height.equalTo(15)
        }
        
        menuRatingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(26)
            $0.height.equalToSuperview()
        }
        
        menuMaxRatingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(27)
            $0.height.equalToSuperview()
        }
        
        cafeteriaNameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Configure Cell
    
    func setMenuTopRankingCell(with menu: MenuRankingSection, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            medalIcon.image = UIImage(named: "GoldMedal")
        case 1:
            medalIcon.image = UIImage(named: "SilverMedal")
        case 2:
            medalIcon.image = UIImage(named: "BronzeMedal")
        default:
            medalIcon.image = nil
        }
        
        if menu.reviewImage == "HomeDefaultMenuImage" {
            menuImageView.image = UIImage(named: menu.reviewImage)
        } else {
            menuImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(menu.reviewImage)"))
        }
        
        menuNameLabel.text = menu.menuName
        menuRatingLabel.text = "\(menu.menuRating) "
        cafeteriaNameLabel.text = "\(menu.cafeteriaName) \(menu.cafeteriaCorner)"
    }
    
    // MARK: - Set Shadow
    
    private func setShadow(to view: UIView) {
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 3).cgPath
        view.layer.shadowColor = UIColor(red: 0.047, green: 0.047, blue: 0.051, alpha: 0.05).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}

