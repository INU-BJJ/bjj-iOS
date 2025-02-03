//
//  CafeteriaMyReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class CafeteriaMyReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // TODO: 서버 데이터로 교체
    private let myReviews = MyReviews.myReviews.studentCafeteriaReviews
    
    // MARK: - UI Components
    
    private lazy var myReviewTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CafeteriaMyReviewCell.self, forCellReuseIdentifier: CafeteriaMyReviewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
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
        setBackNaviBar("학생 식당")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            myReviewTableView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        myReviewTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension CafeteriaMyReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: 서버에서 받아오는 데이터 개수로 변경
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CafeteriaMyReviewCell.reuseIdentifier, for: indexPath) as? CafeteriaMyReviewCell else {
            return UITableViewCell()
        }
        
        let review = myReviews[indexPath.row]
        cell.configureCafeteriaMyReviewCell(with: review)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀당 높이 + 셀 간 간격 (63 + 10)
        return 73
    }
}
