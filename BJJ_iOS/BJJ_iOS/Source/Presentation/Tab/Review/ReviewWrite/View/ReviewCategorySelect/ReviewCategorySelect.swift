//
//  ReviewCategorySelectCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/8/25.
//

import UIKit
import SnapKit
import Then

final class ReviewCategorySelect: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private var isExpanded = false
    private let cafeteriaData = ["학생식당", "2호관 교직원식당", "1기숙사식당", "2호관 교직원식당", "27호관 식당", "사범대식당"]
    
    // MARK: - UI Components
    
    private let dropDownSelectButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 15),
            .foregroundColor: UIColor.black
        ]
        
        configuration.baseBackgroundColor = .white
        configuration.attributedTitle = AttributedString("식당 위치", attributes: AttributeContainer(attributes))
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 18, bottom: 13, trailing: 0)
        configuration.image = UIImage(named: "DropDown")
        configuration.imagePlacement = .trailing
        // TODO: 타이틀라벨의 너비를 258 말고 딱 맞도록 해서 패딩 계산하기
        configuration.imagePadding = 45
        
        $0.configuration = configuration
        $0.contentHorizontalAlignment = .leading
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }
    
    // TODO: 테이블뷰 드롭다운했을때 "식당 위치"버튼보다 뒤로 가도록
    // TODO: 테이블뷰셀 배경색 불투명으로 구현
    private lazy var dropDownTableView = UITableView().then {
        $0.register(ReviewCategorySelectCell.self, forCellReuseIdentifier: ReviewCategorySelectCell.reuseIdentifier)
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
        $0.isHidden = true
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
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
            dropDownSelectButton,
            dropDownTableView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        dropDownSelectButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        dropDownTableView.snp.makeConstraints {
            $0.top.equalTo(dropDownSelectButton.snp.bottom).inset(6)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(229)
        }
    }
    
    // MARK: - Configure DropDown
    
    @objc func showDropDown() {
        isExpanded.toggle()
        
        if isExpanded {
            superview?.bringSubviewToFront(dropDownTableView)
        }
        
        // TODO: Durationg 값 조절
        UIView.animate(withDuration: 0.5) {
            self.dropDownTableView.isHidden = !self.isExpanded
        }
    }
}

extension ReviewCategorySelect: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeteriaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCategorySelectCell.reuseIdentifier, for: indexPath) as! ReviewCategorySelectCell
        cell.configureReviewCategorySelectCell(with: cafeteriaData[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}
