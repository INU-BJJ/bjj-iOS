//
//  ReviewCategorySelectCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/8/25.
//

import UIKit
import SnapKit
import Then
import DropDown

final class ReviewCategorySelectCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    let cafeteriaData = ["학생식당", "2호관 교직원식당", "1기숙사식당"]
    let cafeteriaDropDown = DropDown()
    
    // MARK: - UI Components
    
    private let dropDownSelectButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 15),
            .foregroundColor: UIColor.black
        ]
        
        configuration.baseBackgroundColor = .white
        configuration.attributedTitle = AttributedString("식당 위치", attributes: AttributeContainer(attributes))
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 18, bottom: 13, trailing: 18)
        
        $0.configuration = configuration
        $0.contentHorizontalAlignment = .leading
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
        configureDropDown()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set UI
    
    private func setUI() {
//        contentView.backgroundColor = .white
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            dropDownSelectButton
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        dropDownSelectButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(111)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(45)
        }
    }
    
    // MARK: - Configure Cell
    
    // MARK: - Configure DropDown
    
    private func configureDropDown() {
        cafeteriaDropDown.anchorView = dropDownSelectButton
        cafeteriaDropDown.dataSource = cafeteriaData
        
        dropDownSelectButton.layoutIfNeeded()
        cafeteriaDropDown.bottomOffset = CGPoint(x: 0, y: dropDownSelectButton.bounds.height - 6)
        
        cafeteriaDropDown.direction = .bottom
        cafeteriaDropDown.dismissMode = .automatic
        
        cafeteriaDropDown.textFont = UIFont.customFont(.pretendard_medium, 15)
        cafeteriaDropDown.backgroundColor = .customColor(.backgroundGray)
        cafeteriaDropDown.cellHeight = 45.8
        cafeteriaDropDown.cornerRadius = 3
        
        // TODO: 드롭다운 펼쳤을 때 cell label 위치 조정
        cafeteriaDropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
            cell.optionLabel.textAlignment = .left
//            cell.optionLabel.textInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
            
//            cell.optionLabel.snp.remakeConstraints {
//                $0.leading.equalToSuperview().offset(50)
//                $0.centerY.equalToSuperview()
//            }
        }
        
        // 아이템을 선택했을 때 동작
        cafeteriaDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
        }
    }
    
    @objc func showDropDown() {
        cafeteriaDropDown.show()
    }
}
