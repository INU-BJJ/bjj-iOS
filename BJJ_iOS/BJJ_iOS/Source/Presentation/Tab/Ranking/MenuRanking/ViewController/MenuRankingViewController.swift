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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            menuRankingTitleLabel,
            menuRankingIcon
        ].forEach(view.addSubview)
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
    }
}
