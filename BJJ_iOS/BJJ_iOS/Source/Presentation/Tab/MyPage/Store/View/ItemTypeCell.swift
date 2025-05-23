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

final class ItemTypeCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let testItemImage = UIImageView()
    
    private let testItemValidPeriodLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 13, color: .black)
        $0.textAlignment = .center
        $0.backgroundColor = .customColor(.mainColor)
    }
    
    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = .white
        testItemImage.image = nil
        testItemValidPeriodLabel.text = nil
        testItemImage.transform = .identity
    }
    
    // MARK: - Set AddView
    
    private func setCell() {
        contentView.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        contentView.layer.borderWidth = 3
    }
    
    private func setAddView() {
        [
            testItemImage,
            testItemValidPeriodLabel
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testItemImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        testItemValidPeriodLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    func setUI(itemInfo: StoreSection) {
        DispatchQueue.main.async {
            if itemInfo.isOwned {
                if itemInfo.isWearing {
                    self.contentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                } else {
                    self.contentView.backgroundColor = .white
                }
                guard let characterURL = URL(string: baseURL.characterImageURL + (itemInfo.itemImage)) else { return }
                
                self.testItemImage.sd_setImage(
                    with: characterURL,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                ) { _, _, _, _ in
                    // TODO: 이미지 크기 변경
                    // 이미지 로드 완료 후 크기 변경
                    UIView.animate(withDuration: 0) {
                        self.testItemImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    }
                }
                self.testItemValidPeriodLabel.text = itemInfo.validPeriod
            } else {
                self.contentView.backgroundColor = .customColor(.mainColor)
            }   
        }
    }
}
