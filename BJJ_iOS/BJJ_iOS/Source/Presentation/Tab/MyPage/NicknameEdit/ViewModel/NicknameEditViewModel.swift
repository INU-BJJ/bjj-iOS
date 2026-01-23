//
//  NicknameEditViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import RxSwift
import RxCocoa

final class NicknameEditViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let checkNicknameDuplicate: PublishRelay<String>
        let nickname: BehaviorRelay<String>
//        let signUpButtonTapped: PublishRelay<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let nicknameValidationResult: Driver<NicknameValidationState>
//        let signUpButtonEnabled: Driver<Bool>
//        let signUpResult: Driver<Result<String, Error>>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // 닉네임 변경 시 검증 결과 초기화
        let nicknameChanged = input.nickname
            .map { _ in NicknameValidationState.idle }
        
        // 닉네임 중복 확인
        let nicknameValidation = input.checkNicknameDuplicate
            .flatMapLatest { [weak self] nickname -> Observable<NicknameValidationState> in
                guard let self = self else { return .just(.idle) }
                
                // 닉네임이 비어있는 경우
                if nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return .just(.empty)
                }
                
                // 로딩 상태로 시작
                return Observable.concat([
                    .just(.loading),
                    self.checkNicknameDuplicate(nickname: nickname)
                ])
            }
        
        // 닉네임 검증 결과 병합
        let validationResult = Observable.merge(nicknameChanged, nicknameValidation)
            .asDriver(onErrorJustReturn: .idle)
        
//        // 회원가입 버튼 활성화 여부 (닉네임 검증 성공 AND 전체 동의)
//        let signUpButtonEnabled = Driver.combineLatest(validationResult, isAllAgreedDriver)
//            .map { state, isAllAgreed in
//                if case .available = state, isAllAgreed {
//                    return true
//                }
//                return false
//            }
//        
//        // 회원가입 버튼 탭 -> API 호출
//        let signUpResult = input.signUpButtonTapped
//            .withLatestFrom(input.nickname)
//            .flatMapLatest { [weak self] nickname -> Observable<Result<String, Error>> in
//                guard let self = self else { return .empty() }
//                return self.postSignUp(nickname: nickname)
//            }
//            .asDriver(onErrorJustReturn: .failure(NSError(domain: "SignUpError", code: -1, userInfo: nil)))
//        
        return Output(
            nicknameValidationResult: validationResult,
//            signUpButtonEnabled: signUpButtonEnabled,
//            signUpResult: signUpResult
        )
    }
    
    // MARK: - API Methods
    
    /// 닉네임 중복 확인 API 요청
    private func checkNicknameDuplicate(nickname: String) -> Observable<NicknameValidationState> {
        return Observable.create { observer in
            SignUpAPI.postNickname(nickname: nickname) { result in
                switch result {
                case .success:
                    observer.onNext(.available)
                    observer.onCompleted()

                case .failure:
                    observer.onNext(.duplicate)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    /// 닉네임 변경 API 요청
    private func editNickname(nickname: String) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            SettingAPI.patchNickname(nickname: nickname) { result in
                switch result {
                case .success:
                    observer.onNext(.success(()))
                    observer.onCompleted()

                case .failure(let error):
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

