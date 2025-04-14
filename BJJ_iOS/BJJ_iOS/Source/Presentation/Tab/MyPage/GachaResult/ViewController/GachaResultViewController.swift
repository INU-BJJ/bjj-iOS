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
    
    // MARK: - Post API
    
    private func postItemGacha(itemType: String, completion: @escaping (_ itemInfo: GachaResultModel) -> Void) {
        GachaResultAPI.postItemGacha(itemType: itemType) { result in
            switch result {
            case .success(let itemInfo):
                completion(itemInfo)
                
            case .failure(let error):
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
