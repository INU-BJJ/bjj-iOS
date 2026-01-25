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
        LikedMenuSection(menuID: 0, menuName: "우삼겹떡볶이 * 핫도그"),
        LikedMenuSection(menuID: 1, menuName: "김치볶음밥"),
        LikedMenuSection(menuID: 2, menuName: "우삼겹떡볶이 * 핫도그")
    ])
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Ouptut
    
    struct Output {
        let likedMenuList: BehaviorRelay<[LikedMenuSection]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(likedMenuList: likedMenuList)
    }
}
