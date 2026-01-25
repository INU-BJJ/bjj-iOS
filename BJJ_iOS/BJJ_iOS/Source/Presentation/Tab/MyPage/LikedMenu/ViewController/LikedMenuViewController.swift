//
//  LikedMenuViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/15/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LikedMenuViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = LikedMenuViewModel()
    
    // MARK: - Relay
    
    private let fetchLikedMenuTrigger = PublishRelay<Void>()
    private let toggleMenuLikeTrigger = PublishRelay<Int>()
    
    // MARK: - UI Components
    
    private let likedMenuNotifiLabel = UILabel().then {
        $0.setLabelUI("좋아요 알림 받기", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private let likeNotifySwitch = UISwitch().then {
        $0.onTintColor = .customColor(.mainColor)
    }
    
    private lazy var likedMenuCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(LikedMenuCell.self, forCellWithReuseIdentifier: LikedMenuCell.reuseIdentifier)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 좋아요한 메뉴 조회
        fetchLikedMenuTrigger.accept(())
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("좋아요한 메뉴")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            likedMenuNotifiLabel,
            likeNotifySwitch,
            likedMenuCollectionView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        likedMenuNotifiLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        likeNotifySwitch.snp.makeConstraints {
            $0.centerY.equalTo(likedMenuNotifiLabel)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        likedMenuCollectionView.snp.makeConstraints {
            $0.top.equalTo(likeNotifySwitch.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = LikedMenuViewModel.Input(
            fetchLikedMenuTrigger: fetchLikedMenuTrigger.asObservable(),
            toggleMenuLike: toggleMenuLikeTrigger.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 좋아요한 메뉴
        output.likedMenuList
            .bind(to: likedMenuCollectionView.rx.items(
                cellIdentifier: LikedMenuCell.reuseIdentifier,
                cellType: LikedMenuCell.self
            )) { [weak self] index, likedMenu, cell in
                guard let self = self else { return }
                
                // cell 바인딩
                cell.configureCell(with: likedMenu)
                // 좋아요 버튼 탭 시 좋아요 토글
                cell.likeButton.rx.tap
                    .bind(with: self, onNext: { owner, _ in
                        owner.toggleMenuLikeTrigger.accept(likedMenu.menuID)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
    
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 45)
        layout.minimumLineSpacing = 10
        
        return layout
    }
}
