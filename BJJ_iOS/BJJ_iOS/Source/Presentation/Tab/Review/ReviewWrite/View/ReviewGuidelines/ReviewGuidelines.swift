//
//  ReviewGuidelines.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/24/25.
//

import UIKit
import SnapKit
import Then

final class ReviewGuidelines: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var isExpanded = false
    
    // MARK: - UI Components
    
    private lazy var reviewGuidelineDropDown = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 15),
            .foregroundColor: UIColor.black
        ]
        
        configuration.baseBackgroundColor = .white
        configuration.attributedTitle = AttributedString("리뷰 작성 유의사항", attributes: AttributeContainer(attributes))
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        $0.configuration = configuration
        $0.contentHorizontalAlignment = .leading
        $0.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    
    private let reviewGuidelineLabel = UILabel().then {
        $0.setLabelUI("식당 오픈 전에는 식사 리뷰를 작성하실 수 없습니다.", font: .pretendard_medium, size: 13, color: .warningRed)
        $0.isHidden = true
    }
    
    private let dropDownImage = UIImageView().then {
        $0.image = UIImage(named: "BlackDropDown")
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
            reviewGuidelineDropDown,
            reviewGuidelineLabel
        ].forEach(addSubview)
        
        [
            dropDownImage
        ].forEach(reviewGuidelineDropDown.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        reviewGuidelineDropDown.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        reviewGuidelineLabel.snp.makeConstraints {
            $0.top.equalTo(reviewGuidelineDropDown.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        dropDownImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18)
        }
    }
    
    // MARK: - Configure DropDown
    
    @objc func showDropDown() {
        isExpanded.toggle()
        
        if isExpanded {
            superview?.bringSubviewToFront(reviewGuidelineLabel)
        }
        
        // TODO: Durationg 값 조절
        UIView.animate(withDuration: 10.0) {
            self.reviewGuidelineLabel.isHidden = !self.isExpanded
        }
    }
}
