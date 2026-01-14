//
//  MyPageViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import UIKit
import SnapKit
import Then
import SDWebImage
import RxSwift
import RxCocoa

final class MyPageViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel = MyPageViewModel()
    
    // MARK: - Subjects
    
    private let viewWillAppearTrigger = PublishRelay<Void>()
    
    // MARK: - UI Components
    
    private let nicknameView = MyPageNicknameView()
    
    private let characterImage = UIImageView()
    
    private let backgroundImage = UIImageView()
    
    private lazy var storeButton = UIButton().then {
        $0.setImage(UIImage(named: ImageAsset.store.name), for: .normal)
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearTrigger.accept(())
    }
    
    // MARK: - Set UI

    override func setUI() {
        view.backgroundColor = .white
        setMyPageNaviBar()
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            backgroundImage,
            characterImage,
            storeButton,
            nicknameView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        characterImage.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(170)
            $0.centerX.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        storeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(23)
            $0.leading.equalToSuperview().offset(29)
        }
    }
    
    // MARK: - Bind

    override func bind() {
        let input = MyPageViewModel.Input(
            viewWillAppear: viewWillAppearTrigger
        )
        let output = viewModel.transform(input: input)

        // 닉네임
        output.nickname
            .drive(with: self) { owner, nickname in
                owner.nicknameView.configureNickname(nickname: nickname)
            }
            .disposed(by: disposeBag)

        // 캐릭터 이미지
        output.characterImageURL
            .drive(with: self) { owner, url in
                guard let url = url else { return }
                owner.characterImage.sd_setImage(
                    with: url,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                ) { _, _, _, _ in
                    UIView.animate(withDuration: 0) {
                        owner.characterImage.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    }
                }
            }
            .disposed(by: disposeBag)

        // 배경 이미지
        output.backgroundImageURL
            .drive(with: self) { owner, url in
                guard let url = url else { return }
                owner.backgroundImage.sd_setImage(
                    with: url,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                )
            }
            .disposed(by: disposeBag)
        
        // 상점 버튼 탭
        storeButton.rx.tap
            .withLatestFrom(output.point)
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, point in
                owner.presentStoreViewController(point: point)
            }
            .disposed(by: disposeBag)
    }
}
