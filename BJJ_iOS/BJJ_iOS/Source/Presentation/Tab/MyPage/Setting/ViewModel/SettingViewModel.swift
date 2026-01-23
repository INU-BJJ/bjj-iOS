//
//  SettingViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/21/26.
//

import RxSwift
import RxCocoa

final class SettingViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - DataSource
    
    private let settingList = BehaviorRelay(value: ["닉네임 변경하기", "좋아요한 메뉴", "서비스 이용 약관", "개인정보 처리방침"])
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let settingList: BehaviorRelay<[String]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(settingList: settingList)
    }
}
