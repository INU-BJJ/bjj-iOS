//
//  MyReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/2/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // TODO: 서버 데이터로 교체
    private let myReviews = MyReviews.myReviews
    
    // MARK: - UI Components
    
    private lazy var myReviewTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(MyReviewHeaderView.self, forHeaderFooterViewReuseIdentifier: MyReviewHeaderView.reuseIdentifier)
        $0.register(MyReviewCell.self, forCellReuseIdentifier: MyReviewCell.reuseIdentifier)
        $0.register(MyReviewFooterView.self, forHeaderFooterViewReuseIdentifier: MyReviewFooterView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
    // TODO: 플로팅 버튼 그림자 효과 
    private let floatingButton = UIButton().makeFloatingButton()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setNaviBar("리뷰 페이지")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            myReviewTableView,
            floatingButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        myReviewTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(102)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29.12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(35.12)
        }
    }
}

extension MyReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: 사용자가 작성한 리뷰의 식당 개수에 따라 달라지도록 수정
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myReviews.studentCafeteriaReviews.count
        case 1:
            return myReviews.staffCafeteriaReviews.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewCell.reuseIdentifier, for: indexPath) as? MyReviewCell else {
            return UITableViewCell()
        }
        
        let review = indexPath.section == 0 ? myReviews.studentCafeteriaReviews[indexPath.row] : myReviews.staffCafeteriaReviews[indexPath.row]
        cell.configureMyReviewCell(with: review)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀당 높이 + 셀 간 간격 (63 + 10)
        return 73
    }
    
    //MARK: - TableView Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyReviewHeaderView.reuseIdentifier) as? MyReviewHeaderView else {
            return nil
        }
        
        let cafeteriaName: String
        
        switch section {
        case 0:
            cafeteriaName = "학생식당"
        case 1:
            cafeteriaName = "2호관 교직원식당"
        default:
            cafeteriaName = ""
        }
        headerView.configureMyReviewHeaderView(with: cafeteriaName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 헤더 높이 + 헤더와 섹션 간격 (18 + 7)
        return 25
    }
    
    // MARK: - TableView Footer
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyReviewFooterView.reuseIdentifier) as? MyReviewFooterView else {
            return nil
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // 섹션과 footer 사이의 간격 - 셀 간 간격 + 구분선 높이 + footer와 다음 섹션간의 간격 (24 - 10 + 7 + 22)
        return 43
    }
}
