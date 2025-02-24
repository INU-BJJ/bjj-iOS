//
//  MyReviewHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewHeaderView: UITableViewHeaderFooterView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    // MARK: - Initializer
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            cafeteriaNameLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        cafeteriaNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(40)
        }
    }
    
    // MARK: - Configure HeaderView
    
    func configureMyReviewHeaderView(with cafeteriaName: String) {
        cafeteriaNameLabel.text = cafeteriaName
    }
}
