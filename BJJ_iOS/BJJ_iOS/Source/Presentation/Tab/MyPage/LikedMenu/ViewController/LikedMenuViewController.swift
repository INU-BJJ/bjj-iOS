//
//  LikedMenuViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then

final class LikedMenuViewController: BaseViewController {
    
    // MARK: - UI Components
    
    private let testLikedMenuNotifiLabel = UILabel().then {
        $0.setLabelUI("좋아요 알림 받기", font: .pretendard, size: 15, color: .black)
    }
    
    private lazy var testLikedMenuTableView = UITableView().then {
        $0.register(LikedMenuCell.self, forCellReuseIdentifier: LikedMenuCell.reuseIdentifier)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("좋아요한 메뉴")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            testLikedMenuNotifiLabel,
            testLikedMenuTableView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
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
    
//    // MARK: - Fetch API Functions
//    
//    private func fetchLikedMenu() {
//        SettingAPI.fetchLikedMenu() { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let likedMenuList):
//                self.likedMenuList = likedMenuList.map {
//                    LikedMenuSection(menuID: $0.menuID, menuName: $0.menuName)
//                }
//                
//                DispatchQueue.main.async {
//                    self.testLikedMenuTableView.reloadData()
//                }
//                
//            case .failure(let error):
//                print("[LikedMenuVC] Error: \(error.localizedDescription)")
//            }
//        }
//    }
}

//extension LikedMenuViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        likedMenuList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedMenuCell.reuseIdentifier, for: indexPath) as? LikedMenuCell else {
//            return UITableViewCell()
//        }
//        cell.setCellUI(with: likedMenuList[indexPath.row])
//        
//        return cell
//    }
//}
