//
//  StoreViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/16/26.
//

import RxSwift
import RxCocoa

final class StoreViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
