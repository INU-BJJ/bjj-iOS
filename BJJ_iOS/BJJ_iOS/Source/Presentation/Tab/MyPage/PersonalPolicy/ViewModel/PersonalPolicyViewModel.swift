//
//  PersonalPolicyViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import RxSwift
import RxCocoa

final class PersonalPolicyViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let personalPolicyHTML: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // viewDidLoad시 개인정보 처리방침 API 호출
        let personalPolicyHTML = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else {
                    return Observable.just("")
                }

                return self.fetchPersonalPolicy()
            }
            .asDriver(onErrorJustReturn: "")

        return Output(personalPolicyHTML: personalPolicyHTML)
    }
    
    // MARK: - API Methods
    
    /// 개인정보 처리방침 조회
    private func fetchPersonalPolicy() -> Observable<String> {
        return Observable.create { observer in
            SettingAPI.fetchPersonalPolicy { result in
                switch result {
                case .success(let html):
                    observer.onNext(html)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
