//
//  MenuReviewFooterView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

protocol MenuReviewSortingDelegate: AnyObject {
    func didTapOnlyPhotoReview(isTapped: Bool)
}

final class MenuReviewSorting: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: MenuReviewSortingDelegate?
    private var isChecked = false
    private let sortingCriteria = ["메뉴일치순", "좋아요순", "최신순"]
    private var isReviewSortingExpanded = false
    
    // MARK: - UI Components

    private lazy var onlyPhotoReviewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnlyPhotoCheckBox)))
    }
    
    private let onlyPhotoReviewCheckBox = UIImageView().then {
        $0.image = UIImage(named: "checkBox")
    }
    
    private let onlyPhotoReviewLabel = UILabel().then {
        $0.setLabelUI("포토 리뷰만", font: .pretendard_medium, size: 13, color: .darkGray)
    }
    
    private lazy var reviewToggleButton = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReviewSorting)))
    }
    
    private let toggleLabel = UILabel().then {
        $0.setLabelUI("메뉴일치순", font: .pretendard_medium, size: 13, color: .black)
    }
    
    private let toggleImage = UIImageView().then {
        $0.image = UIImage(named: "toggle")
    }
    
    private lazy var reviewSortingTableView = UITableView().then {
        $0.register(MenuReviewSortingCell.self, forCellReuseIdentifier: MenuReviewSortingCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.isHidden = true
        $0.separatorStyle = .none
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            onlyPhotoReviewStackView,
            reviewToggleButton,
            reviewSortingTableView
        ].forEach(addSubview)
        
        [
            onlyPhotoReviewCheckBox,
            onlyPhotoReviewLabel
        ].forEach(onlyPhotoReviewStackView.addArrangedSubview)
        
        [
            toggleLabel,
            toggleImage
        ].forEach(reviewToggleButton.addArrangedSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        onlyPhotoReviewStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(22)
        }
        
        reviewToggleButton.snp.makeConstraints {
            $0.centerY.equalTo(onlyPhotoReviewStackView)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        reviewSortingTableView.snp.makeConstraints {
            $0.top.equalTo(reviewToggleButton.snp.bottom).offset(11)
            $0.trailing.equalTo(reviewToggleButton.snp.trailing).offset(3)
            $0.width.equalTo(134)
            $0.height.equalTo(93)
        }
    }
    
    // MARK: - Objc Function
    
    @objc private func didTapOnlyPhotoCheckBox() {
        isChecked.toggle()
        let checkBox = isChecked ? "CheckedBox" : "checkBox"
        onlyPhotoReviewCheckBox.image = UIImage(named: checkBox)
        delegate?.didTapOnlyPhotoReview(isTapped: isChecked)
    }
    
    @objc private func didTapReviewSorting() {
        isReviewSortingExpanded.toggle()
        
        UIView.animate(withDuration: 0.5) {
            self.reviewSortingTableView.isHidden = !self.isReviewSortingExpanded
        }
    }
}

// MARK: - UITableView

extension MenuReviewSorting: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingCriteria.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuReviewSortingCell.reuseIdentifier, for: indexPath) as! MenuReviewSortingCell
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        cell.selectionStyle = .none
        cell.configureMenuReviewSortingCell(with: sortingCriteria[indexPath.row])
        cell.hideSeparator(isLastCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 31
    }
}

