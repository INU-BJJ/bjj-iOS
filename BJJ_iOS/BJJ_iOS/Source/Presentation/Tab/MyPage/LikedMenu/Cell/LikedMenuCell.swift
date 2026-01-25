//
//  LikedMenuCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class LikedMenuCell: BaseCollectionViewCell<LikedMenuSection> {
    
    // MARK: - DisposeBag
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let menuNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    let likeButton = UIButton().then {
        $0.setImage(UIImage(named: ImageAsset.EmptyHeart.name), for: .normal)
    }
    
    // MARK: - Reset
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 초기화
        disposeBag = DisposeBag()
        menuNameLabel.text = nil
        likeButton.setImage(UIImage(named: ImageAsset.EmptyHeart.name), for: .normal)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        contentView.setBorder(color: .B_9_B_9_B_9, width: 0.5)
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            menuNameLabel,
            likeButton
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        menuNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9)
            $0.centerY.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(16.88889)
            $0.height.equalTo(16)
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: LikedMenuSection) {
        menuNameLabel.text = data.menuName
    }
}
