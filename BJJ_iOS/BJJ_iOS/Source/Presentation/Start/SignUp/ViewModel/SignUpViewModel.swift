//
//  SignUpViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - DataSource
    
    private let consentList = BehaviorRelay(value: [
        ConsentModel(title: "(필수) 만 14세 이상입니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 서비스 이용약관에 동의합니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 개인정보 수집•이용에 동의합니다.", isRequired: true, isAgreed: false)
    ])
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let consentList: BehaviorRelay<[ConsentModel]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(
            consentList: consentList
        )
    }
}
