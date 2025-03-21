//
//  MenuReviewSortingCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/21/25.
//

import UIKit
import SnapKit
import Then

final class MenuReviewSortingCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let sortingLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
    }
    
    private let separatingView = UIView().then {
        $0.backgroundColor = .customColor(.midGray)
    }
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set UI
    
    private func setUI() {
        backgroundColor = .customColor(.dropDownGray)
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            sortingLabel,
            separatingView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        sortingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15.13)
        }
        
        separatingView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuReviewSortingCell(with sortingCriteria: String) {
        sortingLabel.text = sortingCriteria
    }
    
    // MARK: - Hide Separator
    
    func hideSeparator(_ isHidden: Bool) {
        separatingView.isHidden = isHidden
    }
}

