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

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var myPageViewData: MyPageSection?
    
    // MARK: - UI Components
    
    private let testMyNicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private let testCharacterImage = UIImageView()
    
    private let testBackgroundImage = UIImageView()
    
    private lazy var testStoreButton = UIButton().then {
        $0.setTitle("상점", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderColor = UIColor.customColor(.mainColor).cgColor
        $0.layer.borderWidth = 1
        $0.addTarget(self, action: #selector(didTapStoreButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewController()
        setAddView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: 닉네임을 자주 바꾸진 않으니까 닉네임만 조회하는 API 따로 요청?
        fetchMyPageInfo() {
            self.setUI()
        }
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testBackgroundImage,
            testMyNicknameLabel,
            testCharacterImage,
            testStoreButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testMyNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        testCharacterImage.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(170)
            $0.centerX.equalToSuperview()
        }
        
        testBackgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        testStoreButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
        }
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        DispatchQueue.main.async {
            guard let characterURL = URL(string: baseURL.characterImageURL + (self.myPageViewData?.characterImage ?? "")) else { return }
            guard let backgroundURL = URL(string: baseURL.backgroundImageURL + (self.myPageViewData?.backgroundImage ?? "")) else { return }
            
            self.testMyNicknameLabel.text = "\(self.myPageViewData?.nickname ?? "")의 공간"
            self.testCharacterImage.sd_setImage(
                with: characterURL,
                placeholderImage: nil,
                options: [.retryFailed, .continueInBackground]
            ) { _, _, _, _ in
                // TODO: 이미지 크기 변경
                // 이미지 로드 완료 후 크기 확대
                UIView.animate(withDuration: 0) {
                    self.testCharacterImage.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }
            }
            self.testBackgroundImage.sd_setImage(
                with: backgroundURL,
                placeholderImage: nil,
                options: [.retryFailed, .continueInBackground]
            )
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyPageInfo(completion: @escaping () -> Void) {
        MyPageAPI.fetchMyPageInfo() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let myPageInfo):
                // self.myPageViewData = MyPageSection()과 같은 의미
                myPageViewData = MyPageSection(
                    nickname: myPageInfo.nickname,
                    characterID: myPageInfo.characterID,
                    characterImage: myPageInfo.characterImage,
                    backgroundID: myPageInfo.backgroundID,
                    backgroundImage: myPageInfo.backgroundImage,
                    point: myPageInfo.point
                )
                
                // TODO: patch items/{itemId} 부분 json 형태로 빈 응답이라도 반환해달라고 건의
                // TODO: characterID, backgroundID가 null값으로 들어올 경우 기본 캐릭터 어떤걸 착용할건지 논의
                
                DispatchQueue.main.async {
                    completion()
                }
                
            case .failure(let error):
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapStoreButton() {
        presentStoreViewController(point: myPageViewData?.point ?? 0)
    }
}
