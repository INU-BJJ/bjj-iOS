//
//  MenuInfoHeaderView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuInfoHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "MenuInfoHeaderView"
    
    // MARK: - UI Components
    
    private let headerLabel = UILabel().then {
        $0.setLabelUI("메뉴 구성", font: .pretendard_bold, size: 18, color: .black)
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
        addSubview(headerLabel)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}