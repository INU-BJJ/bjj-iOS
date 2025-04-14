//
//  StoreViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/12/25.
//

import UIKit
import SnapKit
import Then

final class StoreViewController: UIViewController {
    
    // MARK: - Properties
    
    private var point: Int
    private var allItems: [StoreSection] = []
    
    // MARK: - UI Components
    
    private let testPointLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private lazy var testGachaMachine = UIImageView().then {
        $0.image = UIImage(named: "GachaMachine")
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGachaMachine)))
    }
    
    private lazy var testAllItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.register(ItemTypeCell.self, forCellWithReuseIdentifier: ItemTypeCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - LifeCycle
    
    init(point: Int) {
        self.point = point
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllItems(itemType: "CHARACTER")
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testPointLabel,
            testGachaMachine,
            testAllItemCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testPointLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        testGachaMachine.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        testAllItemCollectionView.snp.makeConstraints {
            $0.top.equalTo(testGachaMachine.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setUI() {
        DispatchQueue.main.async {
            // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
            self.testPointLabel.text = "\(self.point) P"
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapGachaMachine() {
        DispatchQueue.main.async {
            // TODO: 백그라운드에서 포인트를 받아와서(마이아이템 API 호출) 뽑기하기 버튼 누를 때 포인트 UI 업데이트
            self.presentGachaViewController()
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchAllItems(itemType: String) {
        StoreAPI.fetchAllItems(itemType: itemType) { result in
            switch result {
            case .success(let allItems):
                self.allItems = allItems.map {
                    StoreSection(
                        itemID: $0.itemID,
                        itemName: $0.itemName,
                        itemType: $0.itemType,
                        itemRarity: $0.itemRarity,
                        itemImage: $0.itemImage,
                        validPeriod: $0.validPeriod,
                        isWearing: $0.isWearing,
                        isOwned: $0.isOwned
                    )
                }
                DispatchQueue.main.async {
                    self.testAllItemCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("[StoreVC] Error: \(error.localizedDescription)")
            }
        }
    }
}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // 첫 번째는 아이템 종류, 두 번째는 아이템
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemTypeCell.reuseIdentifier, for: indexPath) as? ItemTypeCell else {
            return UICollectionViewCell()
        }
        cell.setUI(itemInfo: allItems[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: 100)
    }
}
