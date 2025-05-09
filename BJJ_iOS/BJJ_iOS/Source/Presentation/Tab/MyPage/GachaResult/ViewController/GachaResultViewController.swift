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

final class GachaResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private var drawnItemInfo: GachaResultSection?
    
    // MARK: - UI Components
    
    private let testDrawnCharacter = UIImageView()
    
    private let testGachaPopUpView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let testGachaLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
    }
    
    private lazy var testItemWearButton = UIButton().then {
        $0.setTitle("착용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .customColor(.mainColor)
        $0.addTarget(self, action: #selector(didTapItemWearButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 캐릭터인지 배경인지 구분해서 POST 요청 보내기
        postItemGacha(itemType: "CHARACTER", completion: setUI)
        setViewController()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .systemGreen
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testDrawnCharacter,
            testGachaPopUpView
        ].forEach(view.addSubview)
        
        [
            testGachaLabel,
            testItemWearButton
        ].forEach(testGachaPopUpView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testDrawnCharacter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        testGachaPopUpView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(600)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        testGachaLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.centerX.equalToSuperview()
        }
        
        testItemWearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(173)
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().offset(185)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set UI
    
    private func setUI(_ itemInfo: GachaResultModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let characterURL = URL(string: baseURL.characterImageURL + itemInfo.itemImage) else { return }
            
            self.testDrawnCharacter.sd_setImage(
                with: characterURL,
                placeholderImage: nil,
                options: [.retryFailed, .continueInBackground]
            ) { _, _, _, _ in
                // TODO: 이미지 크기 변경
                // 이미지 로드 완료 후 크기 확대
                UIView.animate(withDuration: 0) {
                    self.testDrawnCharacter.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }
            }
            self.testGachaLabel.text = "\(itemInfo.itemName) 등장!"
        }
    }
    
    // MARK: - Objc Functions
    
    @objc private func didTapItemWearButton() {
        patchItem()
    }
    
    // MARK: - Post API
    
    // TODO: GachaResultModel말고 GachaResultSection사용할지 말지 고민
    private func postItemGacha(itemType: String, completion: @escaping (_ itemInfo: GachaResultModel) -> Void) {
        GachaResultAPI.postItemGacha(itemType: itemType) { result in
            switch result {
            case .success(let itemInfo):
                self.drawnItemInfo = GachaResultSection(itemID: itemInfo.itemID, itemType: itemInfo.itemType)
                completion(itemInfo)
                
            case .failure(let error):
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Patch API
    
    private func patchItem() {
        // TODO: 캐릭터인지 배경인지 구분해서 PATCH 요청 보내기
        // TODO: itemType, itemID가 없을 경우 빈 문자열과 0 보내지 말고 다른 방법 고민하기
        GachaResultAPI.patchItem(itemType: drawnItemInfo?.itemType ?? "", itemID: drawnItemInfo?.itemID ?? 0) { result in
            switch result {
            case .success:
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    // TODO: 계속 아이템을 착용하다보면 네비게이션 스택이 엄청 쌓여서 뒤로가기 한 없이 눌러야됨. 네비게이션 스택을 MyPageVC로 초기화하는 방법 고민
                    self.presentMyPageViewController()
                }
                
            case .failure(let error):
                // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                DispatchQueue.main.async {
                    self.presentMyPageViewController()
                }
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
