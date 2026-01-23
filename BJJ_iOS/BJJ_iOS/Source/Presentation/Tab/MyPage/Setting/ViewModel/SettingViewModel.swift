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
    
    private let settingList = BehaviorRelay(value: SettingMenu.allCases)
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let settingList: BehaviorRelay<[SettingMenu]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(settingList: settingList)
    }
}
