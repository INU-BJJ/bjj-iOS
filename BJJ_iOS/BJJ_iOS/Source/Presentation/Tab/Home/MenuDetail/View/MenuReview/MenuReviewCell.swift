//
//  MenuReviewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class MenuReviewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
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
        contentView.addSubview(imageView)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    func configureReviewCell(reviewImage: String) {
        imageView.kf.setImage(with: URL(string: "\(baseURL.imageURL)\(reviewImage)"))
    }
    
    func configureAddButton() {
        imageView.image = UIImage(named: "+")
        imageView.contentMode = .center
        imageView.backgroundColor = .customColor(.lightGray)
    }
    
    func configureDefaultCell() {
        imageView.backgroundColor = .customColor(.lightGray)
    }
}
