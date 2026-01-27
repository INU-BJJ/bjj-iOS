//
//  MenuRankingViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/12/25.
//

import UIKit
import SnapKit
import Then

final class MenuRankingViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var isUpdatedDate = false
    private var menuRankingData: [MenuRankingSection] = []
    private var currentPageNumber = 0
    private var pageSize = 10
    private var isFetching = false
    private var isLastPage = false
    
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
        $0.setLabelUI("", font: .pretendard_medium, size: 11, color: .darkGray)
    }
    
    private let updateLabel = UILabel().then {
        $0.setLabelUI("업데이트", font: .pretendard_medium, size: 11, color: .darkGray)
    }
    
    private let informationButton = UIButton().then {
        $0.setImage(UIImage(named: "Information"), for: .normal)
    }
    
    private lazy var menuRankingTableView = UITableView().then {
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
        updateDateIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMenuRanking(pageNumber: currentPageNumber, pageSize: pageSize)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .customColor(.backgroundGray)
        setStackView()
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
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
    
    override func setConstraints() {
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
    
    // MARK: - Bind
    
    override func bind() {
        
        // 인포 버튼 탭
        informationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentRankingInfoViewController()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update Date
    
    private func updateDateIfNeeded() {
        guard !isUpdatedDate else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let today = Date()
        let todayDate = dateFormatter.string(from: today)
        
        dateLabel.text = todayDate
        isUpdatedDate = true
    }
    
    // MARK: - API Function
    
    private func fetchMenuRanking(pageNumber: Int, pageSize: Int) {
        guard !isFetching, !isLastPage else { return }
        isFetching = true
        
        RankingAPI.fetchRankingList(
            pageNumber: pageNumber,
            pageSize: pageSize) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let menuRanking):
                    let menuRankingListData = MenuRankingListSection(
                        menuRankingList: menuRanking.menuRankingList.map { menu in
                            MenuRankingSection(
                                menuID: menu.menuID,
                                menuName: menu.menuName,
                                menuRating: menu.menuRating,
                                cafeteriaName: menu.cafeteriaName,
                                cafeteriaCorner: menu.cafeteriaCorner,
                                bestReviewID: menu.bestReviewID,
                                reviewImage: menu.reviewImage ?? "HomeDefaultMenuImage",
                                updatedDate: menu.updatedDate
                            )
                        },
                        isLastPage: menuRanking.isLastPage
                    )
                    
                    DispatchQueue.main.async {
                        self.menuRankingData.append(contentsOf: menuRankingListData.menuRankingList)
                        self.isLastPage = menuRankingListData.isLastPage
                        self.menuRankingTableView.reloadData()
                        self.isFetching = false
                    }
                    
                case .failure(let error):
                    self.presentAlertViewController(alertType: .failure, title: error.localizedDescription)
                }
            }
    }
}

extension MenuRankingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuRankingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTopRankingCell.reuseIdentifier, for: indexPath) as? MenuTopRankingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setMenuTopRankingCell(with: menuRankingData[indexPath.row], indexPath: indexPath)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuRankingCell.reuseIdentifier, for: indexPath) as? MenuRankingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setMenuRankingCell(with: menuRankingData[indexPath.row], indexPath: indexPath)
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewModalVC = ReviewModalViewController(bestReviewID: menuRankingData[indexPath.row].bestReviewID)
        reviewModalVC.modalPresentationStyle = .overCurrentContext
        
        present(reviewModalVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isFetching, !isLastPage else { return }
        
        let currentScrollLoacation = scrollView.contentOffset.y            // 현재 스크롤 위치
        let contentHeight = scrollView.contentSize.height   // 스크롤 가능한 전체 콘텐츠 높이
        let frameHeight = scrollView.frame.size.height      // 스크롤뷰가 차지하는 실제 UI 높이
        
        if currentScrollLoacation > contentHeight - frameHeight - UIScreen.main.bounds.height * 0.1 && !isLastPage {
            currentPageNumber += 1
            fetchMenuRanking(pageNumber: currentPageNumber, pageSize: pageSize)
        }
    }
}
