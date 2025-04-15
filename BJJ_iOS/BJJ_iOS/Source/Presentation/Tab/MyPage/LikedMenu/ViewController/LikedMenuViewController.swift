//
//  LikedMenuViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then

final class LikedMenuViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let testLikedMenuNotifiLabel = UILabel().then {
        $0.setLabelUI("좋아요 알림 받기", font: .pretendard, size: 15, color: .black)
    }
    
    private lazy var testLikedMenuTableView = UITableView().then {
        $0.register(LikedMenuCell.self, forCellReuseIdentifier: LikedMenuCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
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
            testLikedMenuNotifiLabel,
            testLikedMenuTableView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testLikedMenuNotifiLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
        }
        
        testLikedMenuTableView.snp.makeConstraints {
            $0.top.equalTo(testLikedMenuNotifiLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

extension LikedMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedMenuCell.reuseIdentifier, for: indexPath) as? LikedMenuCell else {
            return UITableViewCell()
        }
        cell.setCellUI()
        
        return cell
    }
}
