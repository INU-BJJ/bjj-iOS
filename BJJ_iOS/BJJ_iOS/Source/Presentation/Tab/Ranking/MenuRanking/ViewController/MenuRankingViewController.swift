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
    
    // TODO: 안내 모달 창
    private let informationButton = UIButton().then {
        $0.setImage(UIImage(named: "Information"), for: .normal)
    }
    
    private lazy var menuRankingTableView = UITableView().then {
        // TODO: 그림자 효과
        $0.register(MenuRankingCell.self, forCellReuseIdentifier: MenuRankingCell.reuseIdentifier)
        $0.register(MenuTopRankingCell.self, forCellReuseIdentifier: MenuTopRankingCell.reuseIdentifier)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .customColor(.backgroundGray)
        $0.separatorStyle = .none
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
        view.backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            menuRankingTitleLabel,
            menuRankingIcon,
            dateUpdateStackView,
            menuRankingTableView
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
        
        menuRankingTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(142)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Set StackView
    
    private func setStackView() {
        dateUpdateStackView.setCustomSpacing(5, after: dateLabel)
        dateUpdateStackView.setCustomSpacing(4, after: updateLabel)
    }
}

extension MenuRankingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTopRankingCell.reuseIdentifier, for: indexPath) as? MenuTopRankingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setMenuTopRankingCell(indexPath: indexPath)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuRankingCell.reuseIdentifier, for: indexPath) as? MenuRankingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setMenuRankingCell()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: 터치할 때 아래의 간격도 터치되는 문제 해결하기
        if indexPath.row < 3 {
            // 셀 높이 69 + 셀 간격 13
            return 82
        } else {
            // 셀 높이 54 + 셀 간격 13
            return 67
        }
    }
}
