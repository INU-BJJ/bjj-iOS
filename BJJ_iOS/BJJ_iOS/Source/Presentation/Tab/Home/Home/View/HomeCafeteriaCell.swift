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
    
    private let cafeteriaCellView = UIView().then {
        $0.layer.cornerRadius = 33 / 2
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
    }
    
    private let cafeteriaLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .black)
    }
    
    // MARK: - LifeCycle
        
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
        [
            cafeteriaCellView
        ].forEach(contentView.addSubview)
        
        [
            cafeteriaLabel
        ].forEach(cafeteriaCellView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        cafeteriaCellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cafeteriaLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 9, left: 14, bottom: 9, right: 14))
        }
    }
    
    // MARK: - Configuration
    
    func configureCell(with name: String, isSelected: Bool) {
        cafeteriaLabel.text = name
        cafeteriaLabel.textColor = isSelected ? .white : .customColor(.darkGray)
        cafeteriaCellView.backgroundColor = isSelected ? .customColor(.mainColor) : .white
        cafeteriaCellView.layer.borderColor = isSelected ? UIColor.customColor(.mainColor).cgColor : UIColor.customColor(.darkGray).cgColor
    }
}
