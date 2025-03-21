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
            sortingLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        sortingLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureMenuReviewSortingCell(with sortingCriteria: String) {
        sortingLabel.text = sortingCriteria
    }
}

