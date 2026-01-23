//
//  ServicePolicyViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import RxSwift
import RxCocoa

final class ServicePolicyViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // viewDidLoad시 서비스 이용약관 API 호출
        input.viewDidLoad
        
        return Output()
    }
}
