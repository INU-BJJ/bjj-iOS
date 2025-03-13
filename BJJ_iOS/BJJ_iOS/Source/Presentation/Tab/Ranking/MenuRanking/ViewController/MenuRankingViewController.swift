//
//  MenuRankingViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/12/25.
//

import UIKit
import SnapKit
import Then

final class MenuRankingViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let menuRankingTitleLabel = UILabel().then {
        $0.setLabelUI("Menu Ranking", font: .racingSansOne, size: 30, color: .mainColor)
    }
    
    private let menuRankingIcon = UIImageView().then {
        $0.image = UIImage(named: "Ranking")
    }
    
    private lazy var dateUpdateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let dateLabel = UILabel().then {
        // TODO: 서버 정보 fetch
        $0.setLabelUI("2024.12.26", font: .pretendard_medium, size: 11, color: .darkGray)
    }
    
    private let updateLabel = UILabel().then {
        $0.setLabelUI("업데이트", font: .pretendard_medium, size: 11, color: .darkGray)
    }
    
    private let informationButton = UIButton().then {
        $0.setImage(UIImage(named: "Information"), for: .normal)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
        setStackView()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            menuRankingTitleLabel,
            menuRankingIcon,
            dateUpdateStackView
        ].forEach(view.addSubview)
        
        [
            dateLabel,
            updateLabel,
            informationButton
        ].forEach(dateUpdateStackView.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        menuRankingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(62)
            $0.leading.equalToSuperview().offset(20)
        }
        
        menuRankingIcon.snp.makeConstraints {
            $0.leading.equalTo(menuRankingTitleLabel.snp.trailing).offset(11)
            $0.centerY.equalTo(menuRankingTitleLabel)
        }
        
        dateUpdateStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(101)
            $0.leading.equalToSuperview().offset(254)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set StackView
    
    private func setStackView() {
        dateUpdateStackView.setCustomSpacing(5, after: dateLabel)
        dateUpdateStackView.setCustomSpacing(4, after: updateLabel)
    }
}
