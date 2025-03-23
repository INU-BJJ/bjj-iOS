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
    private var selectedSortingIndex: Int = 0
    
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
        $0.setLineSpacing(kernValue: 0.13, lineHeightMultiple: 1.1)
    }
    
    private let toggleImage = UIImageView().then {
        $0.image = UIImage(named: "toggle")
    }
    
    private lazy var shadowContainerView = UIView().then {
        let firstLayer = CALayer()
        firstLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        firstLayer.shadowOpacity = 1
        firstLayer.shadowRadius = 2.5
        firstLayer.shadowOffset = CGSize(width: 0, height: 1)

        let secondLayer = CALayer()
        secondLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        secondLayer.shadowOpacity = 1
        secondLayer.shadowRadius = 3.9
        secondLayer.shadowOffset = CGSize(width: 0, height: 2)
        
        $0.layer.insertSublayer(firstLayer, at: 0)
        $0.layer.insertSublayer(secondLayer, at: 1)
        $0.layer.setValue(firstLayer, forKey: "firstLayerShadow")
        $0.layer.setValue(secondLayer, forKey: "secondLayerShadow")
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    
    private lazy var reviewSortingTableView = UITableView().then {
        $0.register(MenuReviewSortingCell.self, forCellReuseIdentifier: MenuReviewSortingCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 현재 뷰에서 터치 이벤트 감지
        if let view = super.hitTest(point, with: event) {
            return view //현재 뷰가 터치 가능하면 그대로 반환 (터치 가능 범위 확장 필요 x)
        }

        // 현재 뷰에서 터치 감지 실패 -> 내부 서브뷰 검사
        for subview in subviews {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView // 서브뷰가 터치 가능하면 반환
            }
        }

        return nil // 터치된 곳이 없으면 nil 반환
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            onlyPhotoReviewStackView,
            reviewToggleButton,
            shadowContainerView
        ].forEach(addSubview)
        
        [
            onlyPhotoReviewCheckBox,
            onlyPhotoReviewLabel
        ].forEach(onlyPhotoReviewStackView.addArrangedSubview)
        
        [
            toggleLabel,
            toggleImage
        ].forEach(reviewToggleButton.addArrangedSubview)
        
        [
            reviewSortingTableView
        ].forEach(shadowContainerView.addSubview)
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
        
        shadowContainerView.snp.makeConstraints {
            $0.top.equalTo(reviewToggleButton.snp.bottom).offset(11)
            $0.trailing.equalTo(reviewToggleButton.snp.trailing).offset(3)
            $0.width.equalTo(134)
            $0.height.equalTo(93)
        }
        
        reviewSortingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set Shadow
    
    private func setShadow() {
        let shadowPath = UIBezierPath(roundedRect: shadowContainerView.bounds, cornerRadius: 10).cgPath

        if let firstLayer = shadowContainerView.layer.value(forKey: "firstLayerShadow") as? CALayer {
            firstLayer.shadowPath = shadowPath
            firstLayer.bounds = shadowContainerView.bounds
            firstLayer.position = CGPoint(x: shadowContainerView.bounds.midX, y: shadowContainerView.bounds.midY)
        }

        if let secondLayer = shadowContainerView.layer.value(forKey: "secondLayerShadow") as? CALayer {
            secondLayer.shadowPath = shadowPath
            secondLayer.bounds = shadowContainerView.bounds
            secondLayer.position = CGPoint(x: shadowContainerView.bounds.midX, y: shadowContainerView.bounds.midY)
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
        toggleTableView()
        
        if isReviewSortingExpanded {
            setShadow()
        }
    }
    
    // MARK: - TableView Toggle
    
    private func toggleTableView() {
        isReviewSortingExpanded.toggle()
        
        UIView.animate(withDuration: 0.5) {
            self.shadowContainerView.isHidden = !self.isReviewSortingExpanded
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
        cell.configureMenuReviewSortingCell(
            sortingCriteria: sortingCriteria[indexPath.row],
            isSelected: indexPath.row == selectedSortingIndex
        )
        cell.hideSeparator(isLastCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 31
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleLabel.text = sortingCriteria[indexPath.row]
        toggleTableView()
        selectedSortingIndex = indexPath.row
        tableView.reloadData()
    }
}

