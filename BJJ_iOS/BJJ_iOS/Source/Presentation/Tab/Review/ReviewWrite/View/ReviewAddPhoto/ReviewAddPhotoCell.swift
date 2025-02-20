//
//  ReviewAddPhotoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

final class ReviewPhotoCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    private let addPhotoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "Photo"), for: .normal)
        $0.setTitle("1/4", for: .normal)
        $0.setTitleColor(.customColor(.midGray), for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 13)
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.cornerRadius = 3
//        $0.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    // MARK: - Life Cycle
    
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
        
    }

    // MARK: - Set AddView
    
    private func setAddView() {
        [
            photoImageView,
            addPhotoButton
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure PhotoCell
    
//    func configure(with image: UIImage?) {
//        if let image = image {
//            photoImageView.image = image
//            photoImageView.isHidden = false
//            addPhotoButton.isHidden = true
//        } else {
//            photoImageView.isHidden = true
//            addPhotoButton.isHidden = false
//        }
//    }
}
