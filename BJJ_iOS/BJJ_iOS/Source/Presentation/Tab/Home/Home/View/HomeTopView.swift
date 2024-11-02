//
//  HomeTopView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeTopView: UIView {
    
    // MARK: Properties
    
    private let jumbotronText = """
                                  오늘의 인기 메뉴를
                                  알아볼까요?
                                """
    // MARK: UI Components
    
    private lazy var jumbotronLabel = UILabel().then {
        $0.setLabelUI(jumbotronText, font: .pretendard_semibold, size: 24, color: .black)
        $0.numberOfLines = 0
    }
    
    // MARK: LifeCycle
        
    init() {
        super.init(frame: .zero)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
        
    private func setUI() {
        backgroundColor = .customColor(.mainColor)
    }
    
    // MARK: Set AddViews
    
    private func setAddView() {
        [
         jumbotronLabel
        ].forEach(addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        jumbotronLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.leading.equalToSuperview().offset(31)
            $0.bottom.equalToSuperview().offset(18)
        }
    }
}
