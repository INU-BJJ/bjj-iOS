//
//  ReviewCategorySelectCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/23/25.
//

import UIKit
import SnapKit
import Then

final class ReviewCategorySelectCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .black)
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
        backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            cafeteriaNameLabel
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        cafeteriaNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(18)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureReviewCategorySelectCell(with cafeteriaName: String) {
        cafeteriaNameLabel.text = cafeteriaName
    }
}
