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
    
    private let testCharacterImage = UIImageView()
    
    private let backgroundImage = UIImageView()
    
    private lazy var testStoreButton = UIButton().then {
        $0.setTitle("상점", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        $0.layer.borderWidth = 1
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
            testCharacterImage,
            testStoreButton,
            nicknameView
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        testCharacterImage.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(170)
            $0.centerX.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        testStoreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
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
                owner.testCharacterImage.sd_setImage(
                    with: url,
                    placeholderImage: nil,
                    options: [.retryFailed, .continueInBackground]
                ) { _, _, _, _ in
                    UIView.animate(withDuration: 0) {
                        owner.testCharacterImage.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
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
        
        // 포인트
        output.point
            .drive(with: self) { owner, point in
                // TODO: 포인트를 storeVC로 전달 및 네비게이션
            }
            .disposed(by: disposeBag)
    }
    
//    // MARK: - Objc Functions
//    
//    @objc private func didTapStoreButton() {
//        DispatchQueue.main.async {
//            self.presentStoreViewController(point: self.currentPoint)
//        }
//    }
}
