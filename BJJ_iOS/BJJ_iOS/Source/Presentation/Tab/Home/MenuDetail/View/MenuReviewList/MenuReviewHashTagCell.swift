//
//  HashTagCollectionViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewHashTagCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "HashTagCollectionViewCell"
    
    // MARK: - UI Components
    
    private let hashTagView = UIView().then {
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
    }
    
    private let hashTagLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 11, color: .black)
        $0.textAlignment = .center
    }
    
    // MARK: - Initializer
    
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
        contentView.addSubview(hashTagView)
        hashTagView.addSubview(hashTagLabel)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        hashTagView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        hashTagLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(7)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureHashTag(with text: String, isHighlighted: Bool) {
        hashTagLabel.text = text
        hashTagView.backgroundColor = isHighlighted ? .customColor(.mainColor) : .customColor(.backgroundGray)
    }
}
