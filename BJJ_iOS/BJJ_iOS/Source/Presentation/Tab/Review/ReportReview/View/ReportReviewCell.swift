//
//  ReportReviewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/15/25.
//

import UIKit
import SnapKit
import Then

final class ReportReviewCell: BaseTableViewCell<ReportReason> {
    
    // MARK: - UI Components
    
    private let reportReasonLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 13, color: .black)
    }
    
    // MARK: - Reset
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reportReasonLabel.text = nil
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        selectionStyle = .none
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            reportReasonLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        reportReasonLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(23)
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: ReportReason) {
        reportReasonLabel.text = data.rawValue
    }
}
