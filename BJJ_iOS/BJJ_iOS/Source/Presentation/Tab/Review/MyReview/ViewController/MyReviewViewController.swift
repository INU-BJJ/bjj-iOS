//
//  MyReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/2/25.
//

import UIKit
import SnapKit
import Then
import OrderedCollections

final class MyReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private var myReviews: OrderedDictionary<String, [MyReviewSection]> = [:]
    private let cafeteriaOrder = ["학생식당", "2호관식당", "제1기숙사식당", "27호관식당", "사범대식당"]
    
    // MARK: - UI Components
    
    private let noticeView = NoticeView(type: .review)
    
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
    // TODO: 상태가 터치로 바뀌었을 때 배경색 변경되는 것 수정?
    private lazy var floatingButton = UIButton().makeFloatingButton().then {
        $0.addTarget(self, action: #selector(presentReviewWriteViewController), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myReviews.removeAll()
        fetchMyReview()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setNaviBar("리뷰 페이지")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            noticeView,
            myReviewTableView,
            floatingButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        noticeView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
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
    
    // MARK: - Fetch API
    
    private func fetchMyReview() {
        MyReviewAPI.fetchMyReview() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let myReviewList):
                DispatchQueue.main.async {
                    for cafeteria in self.cafeteriaOrder {
                        guard let reviews = myReviewList.myReviewList[cafeteria] else { continue }

                        let myReview = reviews.map { review in
                            MyReviewSection(
                                reviewID: review.reviewID,
                                reviewComment: review.comment,
                                reviewRating: review.reviewRating,
                                reviewImages: review.reviewImages,
                                reviewLikedCount: review.reviewLikeCount,
                                reviewCreatedDate: review.reviewCreatedDate.convertDateFormat(),
                                menuPairID: review.menuPairID,
                                mainMenuName: review.mainMenuName,
                                subMenuName: review.subMenuName,
                                memberID: review.memberID,
                                memberNickName: review.memberNickname,
                                memberImageName: review.memberImage
                            )
                        }
                        self.myReviews[cafeteria] = myReview
                    }
                    
                    let isMyReviewsEmpty = self.myReviews.isEmpty
                    
                    self.noticeView.setNoticeViewVisibility(isMyReviewsEmpty)
                    self.myReviewTableView.isHidden = isMyReviewsEmpty
                    self.myReviewTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리 (필요 시 UI에 에러 메시지 표시 가능)
                    print("Error fetching menu data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - objc Function
    
    @objc func presentReviewWriteViewController() {
        let reviewWriteVC = ReviewWriteViewController()
        reviewWriteVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reviewWriteVC, animated: true)
    }
}

extension MyReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myReviews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cafeteria = myReviews.keys[section]
        
        return myReviews[cafeteria]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewCell.reuseIdentifier, for: indexPath) as? MyReviewCell else {
            return UITableViewCell()
        }
        
        let cafeteria = myReviews.keys[indexPath.section]
        
        if let review = myReviews[cafeteria]?[indexPath.row] {
            cell.configureMyReviewCell(with: review)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀당 높이 + 셀 간 간격 (63 + 10)
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cafeteria = myReviews.keys[indexPath.section]
        
        if let review = myReviews[cafeteria]?[indexPath.row] {
            let myReviewDetailVC = MyReviewDetailViewController(reviewID: review.reviewID)
            
            myReviewDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myReviewDetailVC, animated: true)
        }
    }
    
    //MARK: - TableView Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyReviewHeaderView.reuseIdentifier) as? MyReviewHeaderView else {
            return nil
        }
        
        let cafeteria = myReviews.keys[section]
        let reviewCountInSection = myReviews[cafeteria]?.count ?? 0

        headerView.configureMyReviewHeaderView(with: cafeteria, section: section)
        headerView.setReviewMoreButtonVisibility(reviewCountInSection >= 3)
        headerView.delegate = self
        
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

extension MyReviewViewController: MyReviewHeaderViewDelegate {
    func didTapReviewMoreButton(in section: Int) {
        let cafeteria = myReviews.keys[section]
        
        presentCafeteriaMyReviewViewController(title: cafeteria)
    }
}
