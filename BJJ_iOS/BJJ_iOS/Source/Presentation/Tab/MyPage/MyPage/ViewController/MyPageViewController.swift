//
//  MyPageViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 4/9/25.
//

import UIKit
import SnapKit
import Then

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var myPageViewData: MyPageSection?
    
    // MARK: - UI Components
    
    private let testMyNicknameLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 15, color: .black)
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
        fetchMyPageInfo()
    }
    
    // MARK: - Set ViewController
    
    private func setViewController() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testMyNicknameLabel
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testMyNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        DispatchQueue.main.async {
            self.testMyNicknameLabel.text = "\(self.myPageViewData?.nickname ?? "")의 공간"
            
            // TODO: 캐릭터, 배경 svg 적용
        }
    }
    
    // MARK: - Fetch API Functions
    
    private func fetchMyPageInfo() {
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
                    backgroundImage: myPageInfo.backgroundImage
                )
                
                // TODO: items/{itemId} 부분 json 형태로 빈 응답이라도 반환해달라고 건의
                // TODO: characterID, backgroundID가 null값으로 들어올 경우 기본 캐릭터 어떤걸 착용할건지 논의
                patchMyItem(
                    characterID: myPageViewData?.characterID ?? 1,
                    backgroundID: myPageViewData?.backgroundID ?? 1
                ) {
                    self.setUI()
                }
                
            case .failure(let error):
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func patchMyItem(characterID: Int, backgroundID: Int, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        // 캐릭터 착용
        dispatchGroup.enter()
        
        MyPageAPI.patchItem(itemType: "CHARACTER", itemID: characterID) { result in
            if case .failure(let error) = result {
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        // 배경 착용
        dispatchGroup.enter()
        
        MyPageAPI.patchItem(itemType: "BACKGROUND", itemID: backgroundID) { result in
            if case .failure(let error) = result {
                print("[MyPageVC] Error: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        // 캐릭터, 배경 착용 완료 후 completion 실행
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
