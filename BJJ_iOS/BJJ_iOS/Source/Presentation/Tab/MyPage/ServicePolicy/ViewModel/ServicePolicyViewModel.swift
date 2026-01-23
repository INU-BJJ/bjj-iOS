//
//  ServicePolicyViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import RxSwift
import RxCocoa

final class ServicePolicyViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let servicePolicyHTML: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // viewDidLoad시 서비스 이용약관 API 호출
        let servicePolicyHTML = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else {
                    return Observable.just("")
                }

                return self.fetchServicePolicy()
            }
            .asDriver(onErrorJustReturn: "")

        return Output(servicePolicyHTML: servicePolicyHTML)
    }
    
    // MARK: - API Methods
    
    /// 서비스 이용약관 조회
    private func fetchServicePolicy() -> Observable<String> {
        return Observable.create { observer in
            SettingAPI.fetchServicePolicy { result in
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
