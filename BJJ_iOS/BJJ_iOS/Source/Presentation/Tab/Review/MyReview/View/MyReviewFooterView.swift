//
//  MyReviewFooterView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/3/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewFooterView: UITableViewHeaderFooterView, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .customColor(.backgroundGray)
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
        addSubview(dividerView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        dividerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(22)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(7)
        }
    }
}

