//
//  ItemTypeCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import UIKit
import SnapKit
import Then
import SDWebImage

final class ItemTypeCell: BaseCollectionViewCell<StoreSection> {
    
    // MARK: - Components
    
    private let itemImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let itemValidPeriodLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_bold, size: 8, color: ._66280_C)
        $0.textAlignment = .center
    }
    
    private let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.isHidden = true
    }
    
    // MARK: - Reset UI
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        itemImage.image = nil
        itemValidPeriodLabel.text = nil
        itemImage.transform = .identity
        backgroundImage.isHidden = true
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        contentView.setCornerRadius(radius: 5)
        contentView.setBorder(color: .FF_9333, width: 2.5)
        contentView.backgroundColor = .F_7941_D
    }
    
    // MARK: Set Hierarchy
    
    override func setHierarchy() {
        [
            itemImage,
            itemValidPeriodLabel,
            backgroundImage
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        itemImage.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(69.5)
        }
        
        itemValidPeriodLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: StoreSection) {
        DispatchQueue.main.async {
            if data.isOwned {
                if data.isWearing {
                    self.updateBackgroundImage(isWearing: true)
                }
                guard let itemImageURL = URL(string: data.itemImage) else { return }
                
                self.itemImage.sd_setImage(
                    with: itemImageURL,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                ) { _, _, _, _ in
                    // TODO: 이미지 크기 변경
                    // 이미지 로드 완료 후 크기 변경
                    UIView.animate(withDuration: 0) {
                        self.itemImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    }
                }
                self.itemValidPeriodLabel.text = data.validPeriod
            } else {
                self.updateBackgroundImage(isWearing: false)
            }
        }
    }
    
    // MARK: - 배경 이미지 업데이트
    
    private func updateBackgroundImage(isWearing: Bool) {
        self.backgroundImage.isHidden = false
        
        if isWearing {
            contentView.setBorder(color: .clear)
            self.backgroundImage.image = nil
            self.backgroundImage.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        } else {
            self.backgroundImage.setImage(.cardBack)
        }
    }
}
