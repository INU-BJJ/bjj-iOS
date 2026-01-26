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
    
    private let cafeteriaName: String
    private var myReviews: [MyReviewSection] = []
    
    // MARK: - UI Components
    
    private lazy var myReviewTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CafeteriaMyReviewCell.self, forCellReuseIdentifier: CafeteriaMyReviewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
    // MARK: - LifeCycle
    
    init(cafeteriaName: String) {
        self.cafeteriaName = cafeteriaName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 무한 스크롤 구현
        fetchCafeteriaMyReview(cafeteriaName: cafeteriaName, pageNumber: 0, pageSize: 10)
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackNaviBar(cafeteriaName)
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
    
    // MARK: - Fetch API
    private func fetchCafeteriaMyReview(cafeteriaName: String, pageNumber: Int, pageSize: Int) {
        CafeteriaMyReviewAPI.fetchMyReview(cafeteriaName: cafeteriaName, pageNumber: pageNumber, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cafeteriaMyreviewList):
                DispatchQueue.main.async {
                    self.myReviews = cafeteriaMyreviewList.myReviewList.map { review in
                        MyReviewSection(
                            reviewID: review.reviewID,
                            reviewComment: review.comment,
                            reviewRating: review.reviewRating,
                            reviewImages: review.reviewImages,
                            reviewLikedCount: review.reviewLikeCount,
                            reviewCreatedDate: DateFormatterManager.shared.convertDateFormat(from: review.reviewCreatedDate),
                            menuPairID: review.menuPairID,
                            mainMenuName: review.mainMenuName,
                            subMenuName: review.subMenuName,
                            memberID: review.memberID,
                            memberNickName: review.memberNickname,
                            memberImageName: review.memberImage
                        )
                    }
                    self.myReviewTableView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching menu data: \(error.localizedDescription)")
            }
        }
    }
}

extension CafeteriaMyReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CafeteriaMyReviewCell.reuseIdentifier, for: indexPath) as? CafeteriaMyReviewCell else {
            return UITableViewCell()
        }
        
        let review = myReviews[indexPath.row]
        cell.configureCafeteriaMyReviewCell(with: review)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀당 높이 + 셀 간 간격 (63 + 10)
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReview = myReviews[indexPath.row]
        let myReviewDetailViewModel = MyReviewDetailViewModel(isOwned: true)
        let myReviewDetailVC = MyReviewDetailViewController(viewModel: myReviewDetailViewModel, reviewID: selectedReview.reviewID)
        
        myReviewDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myReviewDetailVC, animated: true)
    }
}
