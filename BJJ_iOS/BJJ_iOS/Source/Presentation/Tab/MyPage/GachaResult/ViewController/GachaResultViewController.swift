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
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testDrawnCharacter
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testDrawnCharacter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    private func setUI(_ itemImage: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let characterURL = URL(string: baseURL.characterImageURL + itemImage) else { return }
            
            self.testDrawnCharacter.sd_setImage(
                with: characterURL,
                placeholderImage: nil,
                options: [.retryFailed, .continueInBackground]
            )
        }
    }
    
    // MARK: - Post API
    
    private func postItemGacha(itemType: String, completion: @escaping (_ itemImage: String) -> Void) {
        GachaResultAPI.postItemGacha(itemType: itemType) { result in
            switch result {
            case .success(let itemInfo):
                completion(itemInfo.itemImage)
                
            case .failure(let error):
                print("[GachaResultVC] Error: \(error.localizedDescription)")
            }
        }
    }
}
