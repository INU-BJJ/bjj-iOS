//
//  ReportReviewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/15/25.
//

import UIKit
import SnapKit
import Then

final class ReportReviewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let testReportReasonLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .black)
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
        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            testReportReasonLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testReportReasonLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureCell(with reason: ReportReason) {
        testReportReasonLabel.text = reason.rawValue
    }
}
