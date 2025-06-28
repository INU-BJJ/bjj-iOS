//
//  HomeCafeteriaInfoView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/26/25.
//

import UIKit
import SnapKit
import Then

final class HomeCafeteriaInfoView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("식당 정보", font: .pretendard_semibold, size: 18, color: .black)
    }
    
    private let cafeteriaInfoDownArrow = UIImageView().then {
        $0.image = UIImage(named: "CafeteriaInfoDownArrow")
    }
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("식당 이름", font: .pretendard_bold, size: 16, color: .darkGray)
    }
    
    private let cafeteriaLocationLabel = UILabel().then {
        $0.setLabelUI("식당 위치", font: .pretendard_semibold, size: 15, color: .darkGray)
    }
    
    private let serviceHourLabel = UILabel().then {
        $0.setLabelUI("운영 시간", font: .pretendard_bold, size: 15, color: .darkGray)
    }
    
    private let serviceHourView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    
    private let weekDayLabel = UILabel().then {
        $0.setLabelUI("평일", font: .pretendard_semibold, size: 15, color: .darkGray)
    }
    
    private let weekendLabel = UILabel().then {
        $0.setLabelUI("주말", font: .pretendard_semibold, size: 15, color: .darkGray)
    }
    
    private let weekDayLunchHourLabel = UILabel().then {
        $0.setLabelUI("주중 중식 운영시간", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekDayDinnerHourLabel = UILabel().then {
        $0.setLabelUI("주중 석식 운영시간", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekendLunchHourLabel = UILabel().then {
        $0.setLabelUI("주말 중식 운영시간", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekendDinnerHourLabel = UILabel().then {
        $0.setLabelUI("주말 석식 운영시간", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    // MARK: - LifeCycle
        
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
        backgroundColor = .customColor(.backgroundGray)
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            titleLabel,
            cafeteriaInfoDownArrow,
            cafeteriaNameLabel,
            cafeteriaLocationLabel,
            serviceHourLabel,
            serviceHourView
        ].forEach(addSubview)
        
        [
            weekDayLabel,
            weekendLabel,
            weekDayLunchHourLabel,
            weekDayDinnerHourLabel,
            weekendLunchHourLabel,
            weekendDinnerHourLabel
        ].forEach(serviceHourView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(20)
        }
        
        cafeteriaInfoDownArrow.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(titleLabel)
        }
        
        cafeteriaNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(titleLabel)
        }
        
        cafeteriaLocationLabel.snp.makeConstraints {
            $0.top.equalTo(cafeteriaNameLabel)
            $0.leading.equalTo(cafeteriaNameLabel.snp.trailing).offset(20)
        }
        
        serviceHourLabel.snp.makeConstraints {
            $0.top.equalTo(cafeteriaNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(cafeteriaNameLabel)
        }
        
        serviceHourView.snp.makeConstraints {
            $0.top.equalTo(serviceHourLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(76)
        }
        
        weekDayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(66)
            $0.top.equalToSuperview().offset(4)
        }
        
        weekendLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(66)
            $0.top.equalToSuperview().offset(4)
        }
        
        weekDayLunchHourLabel.snp.makeConstraints {
            $0.top.equalTo(weekDayLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(17)
        }
        
        weekDayDinnerHourLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().offset(17)
        }
        
        weekendLunchHourLabel.snp.makeConstraints {
            $0.top.equalTo(weekDayLunchHourLabel)
            // TODO: 구분선을 기준으로 leading값으로 변경
            $0.trailing.equalToSuperview().inset(20)
        }
        
        weekendDinnerHourLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            // TODO: 구분선을 기준으로 leading값으로 변경
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
