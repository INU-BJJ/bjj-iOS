//
//  ReviewAddPhotoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

protocol ReviewAddPhotoDelegate: AnyObject {
    func didTapAddPhoto()
}

final class ReviewAddPhotoCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var delegate: ReviewAddPhotoDelegate?
    
    // MARK: - UI Components
    
    private let photoContainerView = UIView().then {
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let deselectPhotoButton = UIButton().then {
        $0.setImage(UIImage(named: "DeselectXButton"), for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 17 / 2
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var addPhotoButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        let attributedString = NSAttributedString(
            string: "0/4",
            attributes: [
                .font: UIFont.customFont(.pretendard_medium, 13),
                .foregroundColor: UIColor.customColor(.midGray)
            ]
        )
        
        config.image = UIImage(named: "Photo")?.resize(to: CGSize(width: 25, height: 20))
        config.attributedTitle = AttributedString(attributedString)
        config.imagePlacement = .top
        config.imagePadding = 5
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 25, bottom: 15, trailing: 25)
        
        $0.configuration = config
        $0.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder(to: addPhotoButton)
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        
    }

    // MARK: - Set AddView
    
    private func setAddView() {
        [
            photoContainerView,
            addPhotoButton
        ].forEach(addSubview)
        
        [
            photoImageView,
            deselectPhotoButton
        ].forEach(photoContainerView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        photoContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deselectPhotoButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3.73)
            $0.leading.equalToSuperview().offset(53)
            $0.width.height.equalTo(17)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure PhotoCell
    
    func configureAddPhotoCell(with image: UIImage?) {
        if let image = image {
            photoImageView.image = image
            photoContainerView.isHidden = false
            addPhotoButton.isHidden = true
        } else {
            photoContainerView.isHidden = true
            addPhotoButton.isHidden = false
        }
    }
    
    // MARK: - Configure Dash Border Button
    
    // TODO: dash 점선이 왼쪽은 얇고 오른쪽은 두꺼움. 수정 필요
    private func addDashedBorder(to button: UIButton) {
        let dashedBorder = CAShapeLayer()
        
        dashedBorder.strokeColor = UIColor.customColor(.midGray).cgColor
        dashedBorder.lineDashPattern = [2, 2]
        dashedBorder.lineWidth = 1.5
        dashedBorder.fillColor = nil
        dashedBorder.frame = button.bounds
        dashedBorder.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: 3).cgPath
        dashedBorder.masksToBounds = true
        
        button.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        button.layer.addSublayer(dashedBorder)
    }
    
    // MARK: - Objc Function
    
    @objc private func didTapAddPhoto() {
        delegate?.didTapAddPhoto()
    }
}
