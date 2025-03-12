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
    
    weak var delegate: ReviewCategorySelectDelegate?
    private var isCafeteriaTableViewExpanded = false
    private var isMenuTableViewExpanded = false
    private let cafeteriaData = ["학생식당", "2호관식당", "1기숙사식당", "27호관 식당", "사범대식당"]
    private var menuData: [ReviewWriteSection] = []
    
    // MARK: - UI Components
    
    private let dropDownSelectCafeteriaButton = UIButton().then {
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
        $0.addTarget(self, action: #selector(showCafeteriaTableViewDropDown), for: .touchUpInside)
    }
    
    private let dropDownSelectMenuButton = UIButton().then {
        var configuration = UIButton.Configuration.filled()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard_medium, 15),
            .foregroundColor: UIColor.black
        ]
        
        configuration.baseBackgroundColor = .white
        configuration.attributedTitle = AttributedString("메뉴 선택", attributes: AttributeContainer(attributes))
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
        $0.addTarget(self, action: #selector(showMenuTableViewDropDown), for: .touchUpInside)
    }
    
    // TODO: 테이블뷰 드롭다운했을때 "식당 위치"버튼보다 뒤로 가도록
    // TODO: 테이블뷰셀 배경색 불투명으로 구현
    private lazy var dropDownCafeteriaTableView = UITableView().then {
        $0.register(ReviewCategorySelectCell.self, forCellReuseIdentifier: ReviewCategorySelectCell.reuseIdentifier)
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.isHidden = true
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
    }
    
    // TODO: 메뉴 개수가 0개일 때 버튼을 조금 가릴건지 말건지 결정
    private lazy var dropDownMenuTableView = UITableView().then {
        $0.register(ReviewCategorySelectCell.self, forCellReuseIdentifier: ReviewCategorySelectCell.reuseIdentifier)
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 0.5
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 현재 뷰에서 터치 이벤트 감지
        if let view = super.hitTest(point, with: event) {
            return view //현재 뷰가 터치 가능하면 그대로 반환 (터치 가능 범위 확장 필요 x)
        }

        // 현재 뷰에서 터치 감지 실패 -> 내부 서브뷰 검사
        for subview in subviews {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView // 서브뷰가 터치 가능하면 반환
            }
        }

        return nil // 터치된 곳이 없으면 nil 반환
    }

    // MARK: - Set UI
    
    private func setUI() {
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
            dropDownSelectCafeteriaButton,
            dropDownSelectMenuButton,
            dropDownCafeteriaTableView,
            dropDownMenuTableView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        dropDownSelectCafeteriaButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        dropDownSelectMenuButton.snp.makeConstraints {
            $0.top.equalTo(dropDownSelectCafeteriaButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        dropDownCafeteriaTableView.snp.makeConstraints {
            $0.top.equalTo(dropDownSelectCafeteriaButton.snp.bottom).inset(6)
            $0.horizontalEdges.equalToSuperview()
            // TODO: 식당 개수에 따라 높이 동적 할당
            $0.height.equalTo(229)
        }
        
        dropDownMenuTableView.snp.makeConstraints {
            $0.top.equalTo(dropDownSelectMenuButton.snp.bottom).inset(6)
            $0.horizontalEdges.equalToSuperview()
            // TODO: 메뉴 개수에 따라 높이 동적 할당
            $0.height.equalTo(229)
        }
    }
    
    // MARK: - Configure DropDown
    
    @objc func showCafeteriaTableViewDropDown() {
        isCafeteriaTableViewExpanded.toggle()
        
        // TODO: Durationg 값 조절
        UIView.animate(withDuration: 0.5) {
            self.dropDownCafeteriaTableView.isHidden = !self.isCafeteriaTableViewExpanded
        }
    }
    
    @objc func showMenuTableViewDropDown() {
        isMenuTableViewExpanded.toggle()
        
        // TODO: Durationg 값 조절
        UIView.animate(withDuration: 0.5) {
            self.dropDownMenuTableView.isHidden = !self.isMenuTableViewExpanded
        }
    }
    
    // MARK: - Update MenuData
    
    func updateMenuData(_ menuData: [ReviewWriteSection]) {
        self.menuData = menuData
        dropDownMenuTableView.reloadData()
    }
}

// MARK: - TableView Extension

extension ReviewCategorySelect: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == dropDownCafeteriaTableView
            ? cafeteriaData.count
            : menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCategorySelectCell.reuseIdentifier, for: indexPath) as! ReviewCategorySelectCell
        cell.selectionStyle = .none
        
        tableView == dropDownCafeteriaTableView
            ? cell.configureReviewCategorySelectCell(with: cafeteriaData[indexPath.row])
            : cell.configureReviewCategorySelectCell(with: menuData[indexPath.row].mainMenuName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case dropDownCafeteriaTableView:
            let selectedCafeteria = cafeteriaData[indexPath.row]
            var newConfiguration = dropDownSelectCafeteriaButton.configuration
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.customFont(.pretendard_medium, 15),
                .foregroundColor: UIColor.black
            ]
            newConfiguration?.attributedTitle = AttributedString(selectedCafeteria, attributes: AttributeContainer(attributes))
            dropDownSelectCafeteriaButton.configuration = newConfiguration
            
            UIView.animate(withDuration: 0.5) {
                self.dropDownCafeteriaTableView.isHidden = true
            }
            
            delegate?.didSelectCafeteria(selectedCafeteria, sender: self)
            
        case dropDownMenuTableView:
            let selectedMenu = menuData[indexPath.row]
            var newConfiguration = dropDownSelectMenuButton.configuration
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.customFont(.pretendard_medium, 15),
                .foregroundColor: UIColor.black
            ]
            newConfiguration?.attributedTitle = AttributedString(selectedMenu.mainMenuName, attributes: AttributeContainer(attributes))
            dropDownSelectMenuButton.configuration = newConfiguration
            
            UIView.animate(withDuration: 0.5) {
                self.dropDownMenuTableView.isHidden = true
            }
            
            delegate?.didSelectMenu(selectedMenu.menuPairID)

        default:
            fatalError("Unexpected section")
        }
    }
}
