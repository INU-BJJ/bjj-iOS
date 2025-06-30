//
//  HomeCafeteriaInfoView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/26/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HomeCafeteriaInfoView: UIView {
    
    // MARK: - Properties
    
    private var weekDaysServiceTimeLeading: Constraint?
    private var weekendsServiceTimeLeading: Constraint?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("식당 정보", font: .pretendard_semibold, size: 18, color: .black)
    }
    
    private let cafeteriaInfoDownArrow = UIImageView().then {
        $0.image = UIImage(named: "CafeteriaInfoDownArrow")
    }
    
    private let cafeteriaNameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 16, color: .darkGray)
    }
    
    private let cafeteriaLocationLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 15, color: .darkGray)
    }
    
    private let serviceHourLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 15, color: .darkGray)
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
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekDayDinnerHourLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekendLunchHourLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekendDinnerHourLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
    }
    
    private let weekDaysServiceTimeLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
        $0.isHidden = true
    }
    
    private let weekendsServiceTimeLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 15, color: .darkGray)
        $0.isHidden = true
    }
    
    private let verticalLine = UIView().then {
        $0.backgroundColor = .customColor(.darkGray)
    }
    
    private let horizontalLine = UIView().then {
        $0.backgroundColor = .customColor(.darkGray)
    }
    
    private let cafeteriaMap = UIImageView().then {
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
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
            serviceHourView,
            cafeteriaMap
        ].forEach(addSubview)
        
        [
            weekDayLabel,
            weekendLabel,
            weekDayLunchHourLabel,
            weekDayDinnerHourLabel,
            weekendLunchHourLabel,
            weekendDinnerHourLabel,
            weekDaysServiceTimeLabel,
            weekendsServiceTimeLabel,
            verticalLine,
            horizontalLine
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
            // TODO: 휴점 문구도 없을 경우의 높이 고려?
            $0.height.equalTo(76)
        }
        
        weekDayLabel.snp.makeConstraints {
            $0.centerX.equalTo(verticalLine.snp.leading).multipliedBy(0.5)
            $0.centerY.equalTo(horizontalLine.snp.top).multipliedBy(0.5)
        }
        
        weekendLabel.snp.makeConstraints {
            $0.centerX.equalTo(verticalLine.snp.centerX).multipliedBy(1.5)
            $0.centerY.equalTo(horizontalLine.snp.top).multipliedBy(0.5)
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
            $0.leading.equalTo(verticalLine.snp.trailing).offset(17)
        }
        
        weekendDinnerHourLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.leading.equalTo(verticalLine.snp.trailing).offset(17)
        }
        
        weekDaysServiceTimeLabel.snp.makeConstraints {
            $0.top.equalTo(horizontalLine.snp.bottom).offset(15)
            weekDaysServiceTimeLeading = $0.leading.equalTo(weekDayLabel.snp.leading).offset(-49).constraint
        }
        
        weekendsServiceTimeLabel.snp.makeConstraints {
            $0.top.equalTo(horizontalLine.snp.bottom).offset(15)
            weekendsServiceTimeLeading = $0.leading.equalTo(weekendLabel.snp.leading).offset(-49).constraint
        }
        
        verticalLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
            $0.verticalEdges.equalToSuperview()
        }
        
        horizontalLine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        cafeteriaMap.snp.makeConstraints {
            $0.top.equalTo(serviceHourView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(212)
        }
    }
    
    // MARK: - Configure View
    
    func configureCafeteriaInfoView(with cafeteriaInfo: HomeCafeteriaInfoSection) {
        let weekDaysTimeCount = cafeteriaInfo.serviceTime.weekDaysServiceTime.count
        let weekendsTimeCount = cafeteriaInfo.serviceTime.weekendsServiceTime.count
        
        cafeteriaNameLabel.text = cafeteriaInfo.cafeteriaName
        cafeteriaLocationLabel.text = cafeteriaInfo.cafeteriaLocation
        serviceHourLabel.text = cafeteriaInfo.serviceTime.serviceHourTitle
        
        // 주중 운영시간
        switch weekDaysTimeCount {
        case 1:
            weekDayLunchHourLabel.isHidden = true
            weekDayDinnerHourLabel.isHidden = true
            weekDaysServiceTimeLabel.text = cafeteriaInfo.serviceTime.weekDaysServiceTime[0]
            weekDaysServiceTimeLabel.isHidden = false
            
            if cafeteriaInfo.serviceTime.weekDaysServiceTime[0].contains("휴점") {
                weekDaysServiceTimeLeading?.update(offset: 0)
            } else {
                weekDaysServiceTimeLeading?.update(offset: -49)
            }
            
        case 2:
            weekDayLunchHourLabel.text = cafeteriaInfo.serviceTime.weekDaysServiceTime[0]
            weekDayDinnerHourLabel.text = cafeteriaInfo.serviceTime.weekDaysServiceTime[1]
            
        default:
            weekDayLunchHourLabel.isHidden = true
            weekDayDinnerHourLabel.isHidden = true
        }
        
        // 주말 운영시간
        switch weekendsTimeCount {
        case 1:
            weekendLunchHourLabel.isHidden = true
            weekendDinnerHourLabel.isHidden = true
            weekendsServiceTimeLabel.text = cafeteriaInfo.serviceTime.weekendsServiceTime[0]
            weekendsServiceTimeLabel.isHidden = false
            
            if cafeteriaInfo.serviceTime.weekendsServiceTime[0].contains("휴점") {
                weekendsServiceTimeLeading?.update(offset: 0)
            } else {
                weekendsServiceTimeLeading?.update(offset: -49)
            }
            
        case 2:
            weekendLunchHourLabel.text = cafeteriaInfo.serviceTime.weekendsServiceTime[0]
            weekendDinnerHourLabel.text = cafeteriaInfo.serviceTime.weekendsServiceTime[1]
            
        default:
            weekendLunchHourLabel.isHidden = true
            weekendDinnerHourLabel.isHidden = true
        }
        
        cafeteriaMap.kf.setImage(with: URL(string: "\(baseURL.cafeteriaMapImageURL)\(cafeteriaInfo.cafeteriaMapImage)"))
    }
}
