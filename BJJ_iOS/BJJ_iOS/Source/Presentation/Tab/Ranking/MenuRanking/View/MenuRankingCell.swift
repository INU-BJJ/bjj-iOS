//
//  MenuRankingCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/13/25.
//

import UIKit
import SnapKit
import Then

final class MenuRankingCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let menuRankingCellView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    
    private let rankingLabel = UILabel().then {
        $0.setLabelUI("1", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("우삼겹 비빔면", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let menuInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .trailing
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    private let menuRatingView = MenuRatingView()
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("학생식당 2코너", font: .pretendard, size: 11, color: .darkGray)
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
        
        setShadow(to: menuRankingCellView)
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        contentView.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        contentView.addSubview(menuRankingCellView)
        
        [
            rankingLabel,
            menuNameLabel,
            menuInfoStackView
        ].forEach(menuRankingCellView.addSubview)
        
        [
            menuRatingView,
            cafeteriaNameLabel
        ].forEach(menuInfoStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuRankingCellView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 13, right: 0))
        }
        
        rankingLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        menuNameLabel.snp.makeConstraints {
            $0.leading.equalTo(rankingLabel.snp.trailing).offset(22)
            $0.centerY.equalToSuperview()
        }
        
        menuInfoStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
        }
        
        menuRatingView.snp.makeConstraints {
            $0.width.equalTo(53)
            $0.height.equalTo(21)
        }
    }
    
    // MARK: - Configure Cell
    
    func setMenuRankingCell() {
        menuRatingView.configureRatingLabel(with: 4.2)
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
