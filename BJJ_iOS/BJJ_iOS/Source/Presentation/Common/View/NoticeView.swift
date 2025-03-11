//
//  NoticeView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/5/25.
//

import UIKit
import SnapKit
import Then

final class NoticeView: UIView {
    
    // MARK: - Properties
    
    private let type: NoticeViewType
    
    // MARK: - UI Components
    
    private let noticeImageView = UIImageView().then {
        $0.image = UIImage(named: "Notice")
        $0.contentMode = .scaleAspectFit
    }
    
    private let noticeLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 18, color: .lightGray)
    }
    
    // MARK: - Initializer

    init(type: NoticeViewType) {
        self.type = type
        super.init(frame: .zero)
        
        setAddView()
        setConstraints(type: type)
        configureNoticeLabel(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        [
            noticeImageView,
            noticeLabel
        ].forEach(addSubview)
    }
    
    private func setConstraints(type: NoticeViewType) {
        noticeImageView.snp.removeConstraints()
        
        switch type {
        // TODO: 홈 탭의 noticeView 제약 재설정
        case .home:
            noticeImageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(278)
                $0.centerX.equalToSuperview()
            }
            
        case .review:
            noticeImageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(182)
                $0.centerX.equalToSuperview()
            }
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.bottom).offset(20.25)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureNoticeLabel(type: NoticeViewType) {
        noticeLabel.text = type.message
    }
    
    // MARK: - Public Method
    
    func setNoticeeViewVisibility(_ isVisible: Bool) {
        self.isHidden = !isVisible
    }
}
