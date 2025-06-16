//
//  ReportReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/15/25.
//

import UIKit
import SnapKit
import Then

final class ReportReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var testReportReviewTableView = UITableView().then {
        $0.register(ReportReviewCell.self, forCellReuseIdentifier: ReportReviewCell.reuseIdentifier)
        $0.dataSource = self
        $0.separatorStyle = .none
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
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testReportReviewTableView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testReportReviewTableView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: UITableView DataSource

extension ReportReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportReviewCell.reuseIdentifier, for: indexPath) as? ReportReviewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        return cell
    }
}
