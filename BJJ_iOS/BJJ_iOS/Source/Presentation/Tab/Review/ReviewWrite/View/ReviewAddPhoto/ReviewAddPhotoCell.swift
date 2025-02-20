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
        $0.setImage(UIImage(named: "Photo"), for: .normal)
        $0.setTitle("0/4", for: .normal)
        $0.setTitleColor(.customColor(.midGray), for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_medium, 13)
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
