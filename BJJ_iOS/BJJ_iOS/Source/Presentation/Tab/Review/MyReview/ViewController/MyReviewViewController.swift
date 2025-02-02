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
    
    private lazy var myReviewTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyReviewCell.self, forCellReuseIdentifier: MyReviewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
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
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(31)
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29.12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(35.12)
        }
    }
}

extension MyReviewViewController: UITableViewDelegate, UITableViewDataSource {
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
        return 63
    }
}
