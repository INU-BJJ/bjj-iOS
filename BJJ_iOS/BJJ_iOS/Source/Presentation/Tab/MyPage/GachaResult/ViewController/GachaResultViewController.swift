//
//  GachaResultViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/14/25.
//

import UIKit
import SnapKit
import Then
import SDWebImage
import RxSwift
import RxCocoa

final class GachaResultViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let gachaResultViewModel: GachaResultViewModel
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.setImage(.storeBackground)
    }
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: ImageAsset.BlackBackButton.name), for: .normal)
    }
    
    private let itemImageView = UIImageView()
    
    private let gachaResultView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.setCornerRadius(radius: 25)
        $0.setShadow(opacity: 0.1, shadowRadius: 7.5, x: 0, y: -3)
    }
    
    private let gachaResultTitleLabel = UILabel().then {
        $0.setLabelUI("흔 한 양 파 등장!", font: .pretendard_semibold, size: 24, color: .black)
    }
    
    private let gachaDescriptionLabel = UILabel().then {
        $0.setLabel("", font: .pretendard_semibold, size: 15, color: ._999999)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let dismissButton = ConfirmButton(title: "닫기", backgroundColor: .B_9_B_9_B_9)
    
    private lazy var itemWearButton = ConfirmButton(title: "착용하기")
    
    // MARK: - Init
    
    init(viewModel: GachaResultViewModel) {
        gachaResultViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            backgroundImageView,
            backButton,
            itemImageView,
            gachaResultView
        ].forEach(view.addSubview)
        
        [
            gachaResultTitleLabel,
            gachaDescriptionLabel,
            dismissButton,
            itemWearButton
        ].forEach(gachaResultView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        itemImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(gachaResultView.snp.top).offset(-153.89)
        }
        
        gachaResultView.snp.makeConstraints {
            $0.height.equalTo(260)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        gachaResultTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.centerX.equalToSuperview()
        }
        
        gachaDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(gachaResultTitleLabel.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.equalTo(20)
            $0.width.equalTo((UIScreen.main.bounds.width - 20 * 2 - 10) / 2)
            $0.height.equalTo(47)
        }
        
        itemWearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.size.equalTo(dismissButton)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = GachaResultViewModel.Input(
            viewDidLoad: Observable.just(())
        )
        let output = gachaResultViewModel.transform(input: input)
        
        // 백버튼 탭
        backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentingViewController?.presentingViewController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 착용하기 버튼 탭
        itemWearButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.patchItem()
            }
            .disposed(by: disposeBag)
        
        // 뽑기 결과 설명 텍스트 설정
        output.itemType
            .bind(with: self, onNext: { owner, itemTexts in
                owner.gachaDescriptionLabel.text = "뽑기를 해서 랜덤으로 \(itemTexts[0]) 얻어요.\n뽑은 \(itemTexts[1]) 7일의 유효기간이 있어요."
            })
            .disposed(by: disposeBag)
        
        // 아이템 이미지 URL 바인딩
        output.itemImageURL
            .drive(with: self, onNext: { owner, url in
                guard let url = url else { return }
                owner.itemImageView.sd_setImage(
                    with: url,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                ) { _, _, _, _ in
                    // 이미지 로드 완료 후 크기 확대
                    UIView.animate(withDuration: 0) {
                        owner.itemImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // 아이템 타이틀 바인딩
        output.itemTitle
            .drive(gachaResultTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Patch API
    
    private func patchItem() {
        // ViewModel에서 drawnItemInfo 가져오기
        guard let drawnItemInfo = gachaResultViewModel.getDrawnItemInfo() else {
            print("[GachaResultVC] Error: drawnItemInfo is nil")
            return
        }
        
        GachaResultAPI.patchItem(itemType: drawnItemInfo.itemType, itemID: drawnItemInfo.itemID) { result in
            switch result {
            case .success:
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false) {
                        
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                           let tabBarController = sceneDelegate.window?.rootViewController as? UITabBarController,
                           let viewControllers = tabBarController.viewControllers {
                            
                            for vc in viewControllers {
                                if let navigationVC = vc as? UINavigationController,
                                   navigationVC.viewControllers.first is MyPageViewController {
                                    tabBarController.selectedViewController = navigationVC
                                    navigationVC.popToRootViewController(animated: true)
                                    break
                                }
                            }
                        } else {
                            print("[GachaResultVC] Error: TabBarController 또는 MyPageVC 탐색 실패")
                        }
                    }
                }
                
            case .failure(let error):
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false) {
                        
                        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                           let tabBarController = sceneDelegate.window?.rootViewController as? UITabBarController,
                           let viewControllers = tabBarController.viewControllers {
                            
                            for vc in viewControllers {
                                if let navigationVC = vc as? UINavigationController,
                                   navigationVC.viewControllers.first is MyPageViewController {
                                    tabBarController.selectedViewController = navigationVC
                                    navigationVC.popToRootViewController(animated: true)
                                    break
                                }
                            }
                        } else {
                            print("[GachaResultVC] Error: TabBarController 또는 MyPageVC 탐색 실패")
                        }
                    }
                }
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
