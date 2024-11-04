//
//  HomeCafeteriaCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 10/7/24.
//

import UIKit
import SnapKit
import Then

final class HomeCafeteriaCell: UICollectionViewCell {
    
    // TODO: identifier 삭제
    
    static let identifier = "HomeCafeteriaCell"
    
    // MARK: - UI Components
    
    // TODO: 선택 여부에 따라 텍스트 색 변경하기
    private let cafeteriaLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .black)
    }
    
    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {
        self.backgroundColor = .customColor(.mainColor)
        self.layer.cornerRadius = 100
        self.layer.masksToBounds = true
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         cafeteriaLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {  
        cafeteriaLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 9, left: 14, bottom: 9, right: 14))
        }
    }
    
    // MARK: - Configuration
    
    func configureCell(with name: String) {
        cafeteriaLabel.text = name
    }
}
