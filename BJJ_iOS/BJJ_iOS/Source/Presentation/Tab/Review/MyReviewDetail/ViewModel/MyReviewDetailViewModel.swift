//
//  MyReviewDetailViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import RxSwift
import RxCocoa

final class MyReviewDetailViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    let isOwned: Bool
    
    // MARK: - Init
    
    init(isOwned: Bool) {
        self.isOwned = isOwned
    }
    
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
