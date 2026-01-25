//
//  LikedMenuViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import RxSwift
import RxCocoa

final class LikedMenuViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - DataSource
    
    private let likedMenuList = BehaviorRelay(value: [
        "우삼겹떡볶이 * 핫도그",
        "김치볶음밥",
        "우삼겹떡볶이 * 핫도그"
    ])
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Ouptut
    
    struct Output {
        let likedMenuList: BehaviorRelay<[String]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(likedMenuList: likedMenuList)
    }
}
