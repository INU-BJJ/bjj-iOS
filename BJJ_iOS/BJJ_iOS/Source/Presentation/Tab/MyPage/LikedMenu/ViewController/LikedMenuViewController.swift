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
    private let viewWillAppearTrigger = PublishRelay<Void>()
    private let sceneDidBecomeActiveTrigger = PublishRelay<Void>()
    private let likeNotifySwitchTappedTrigger = PublishRelay<Bool>()
    
    // MARK: - UI Components
    
    private let likedMenuNotifiLabel = UILabel().then {
        $0.setLabelUI("좋아요 알림 받기", font: .pretendard_semibold, size: 15, color: .black)
    }
    
    private let likeNotifySwitch = UISwitch().then {
        $0.onTintColor = .customColor(.mainColor)
    }
    
    private let overlaySwitchButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
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
        
        // sceneDidBecomeActive 알림 옵저버 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 나타날 때마다 알림 권한 체크 및 스위치 상태 로드
        viewWillAppearTrigger.accept(())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            overlaySwitchButton,
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
        
        overlaySwitchButton.snp.makeConstraints {
            $0.edges.equalTo(likeNotifySwitch)
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
            toggleMenuLike: toggleMenuLikeTrigger.asObservable(),
            viewWillAppear: viewWillAppearTrigger.asObservable(),
            sceneDidBecomeActive: sceneDidBecomeActiveTrigger.asObservable(),
            likeNotifySwitchTapped: likeNotifySwitchTappedTrigger.asObservable()
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
        
        // 에러 메시지 처리
        output.errorMessage
            .bind(with: self, onNext: { owner, message in
                owner.presentAlertViewController(
                    alertType: .failure,
                    title: message
                )
            })
            .disposed(by: disposeBag)
        
        // 스위치 상태 업데이트
        output.likeNotifySwitchState
            .bind(to: likeNotifySwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        // 알림 권한 상태에 따른 스위치 및 버튼 제어
        output.isNotificationAuthorized
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, isAuthorized in
                if isAuthorized {
                    // 알림 권한이 있을 때: 스위치 활성화, 오버레이 버튼 숨김
                    owner.likeNotifySwitch.isEnabled = true
                    owner.overlaySwitchButton.isHidden = true
                } else {
                    // 알림 권한이 없을 때: 스위치 비활성화, 오버레이 버튼 표시
                    owner.likeNotifySwitch.isEnabled = false
                    owner.overlaySwitchButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        // 오버레이 버튼 탭 (알림 권한이 없을 때만 표시됨)
        overlaySwitchButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showAlert(
                    title: "알림 설정",
                    message: "기기의 알림 설정이 꺼져있어요!\n[설정] > [앱] > [밥점줘]에서\n설정을 변경해주세요.",
                    cancelTitle: "취소",
                    confirmTitle: "설정 변경하기"
                ) {
                    // iOS 설정 앱으로 이동
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // 스위치 탭 이벤트
        likeNotifySwitch.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in
                self?.likeNotifySwitch.isOn ?? false
            }
            .bind(to: likeNotifySwitchTappedTrigger)
            .disposed(by: disposeBag)
    }

    // MARK: - Selector Methods
    
    @objc private func sceneDidBecomeActive() {
        sceneDidBecomeActiveTrigger.accept(())
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
