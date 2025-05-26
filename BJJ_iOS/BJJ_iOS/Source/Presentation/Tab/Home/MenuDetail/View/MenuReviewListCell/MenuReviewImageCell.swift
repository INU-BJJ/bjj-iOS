//
//  MenuReviewImageCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/24/24.
//

import UIKit

final class MenuReviewImageCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private let cornerRadius: CGFloat = 11
    
    // MARK: - UI Components
    
    private let reviewImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
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
        [
            reviewImageView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints {
    
    private func setConstraints() {
        reviewImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureReviewImageCell(with imageName: String, cornerStyle: UIRectCorner) {
        reviewImageView.kf.setImage(with: URL(string: "\(baseURL.reviewImageURL)\(imageName)"))
        applyCorners(cornerStyle: cornerStyle)
    }
    
    private func applyCorners(cornerStyle: UIRectCorner) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: cornerStyle,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        reviewImageView.layer.mask = mask
    }
}
