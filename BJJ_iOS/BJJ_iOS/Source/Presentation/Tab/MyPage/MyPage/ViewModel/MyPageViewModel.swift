//
//  MyPageViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/14/26.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    
    struct Input {
        let viewWillAppear: PublishRelay<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let nickname: Driver<String>
        let characterImageURL: Driver<URL?>
        let backgroundImageURL: Driver<URL?>
        let point: Driver<Int>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        let myPageInfo = PublishRelay<MyPageSection>()
        
        // viewWillAppear
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.fetchMyPageInfo { result in
                    if let data = result {
                        myPageInfo.accept(data)
                    }
                }
            }
            .disposed(by: disposeBag)

        // 닉네임
        let nickname = myPageInfo
            .map { "\($0.nickname)의 공간" }
            .asDriver(onErrorJustReturn: "알 수 없음의 공간")
        
        // 캐릭터 이미지 url
        let characterImageURL = myPageInfo
            .map { data -> URL? in
                guard let imagePath = data.characterImage else { return nil }
                let urlString = baseURL.characterImageURL + "main_" + imagePath + ".svg"
                return URL(string: urlString)
            }
            .asDriver(onErrorJustReturn: nil)
        
        // 배경 이미지 url
        let backgroundImageURL = myPageInfo
            .map { data -> URL? in
                guard let imagePath = data.backgroundImage else { return nil }
                return URL(string: baseURL.backgroundImageURL + imagePath + ".svg")
            }
            .asDriver(onErrorJustReturn: nil)
        
        // 포인트
        let point = myPageInfo
            .map { $0.point }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(
            nickname: nickname,
            characterImageURL: characterImageURL,
            backgroundImageURL: backgroundImageURL,
            point: point
        )
    }
    
    // MARK: - API Methods
    
    private func fetchMyPageInfo(completion: @escaping (MyPageSection?) -> Void) {
        MyPageAPI.fetchMyPageInfo() { result in
            switch result {
            case .success(let myPageInfo):
                let data = MyPageSection(
                    nickname: myPageInfo.nickname,
                    characterID: myPageInfo.characterID,
                    characterImage: myPageInfo.characterImage,
                    backgroundID: myPageInfo.backgroundID,
                    backgroundImage: myPageInfo.backgroundImage,
                    point: myPageInfo.point
                )
                completion(data)

            case .failure(let error):
                print("[MyPageViewModel] Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
