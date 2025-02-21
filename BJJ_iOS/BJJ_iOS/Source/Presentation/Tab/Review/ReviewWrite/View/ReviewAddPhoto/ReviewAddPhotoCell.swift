//
//  ReviewAddPhotoCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/20/25.
//

import UIKit
import SnapKit
import Then

final class ReviewAddPhotoCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isHidden = true
    }
    
    private let addPhotoButton = UIButton().then {
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
    
    func configureAddPhotoCell(with image: String?) {
        if let image = image, !image.isEmpty {
            photoImageView.image = UIImage(named: image)
            photoImageView.isHidden = false
            addPhotoButton.isHidden = true
        } else {
            photoImageView.isHidden = true
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
        
        button.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        button.layer.addSublayer(dashedBorder)
    }
}
