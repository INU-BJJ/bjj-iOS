//
//  SignUpViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import RxSwift
import RxCocoa

// MARK: - Nickname Validation State

enum NicknameValidationState {
    case idle
    case loading
    case available
    case duplicate
    case empty
}

final class SignUpViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let email: String
    private let provider: String
    
    // MARK: - DataSource
    
    private let consentList = BehaviorRelay(value: [
        ConsentModel(title: "(필수) 만 14세 이상입니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 서비스 이용약관에 동의합니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 개인정보 수집•이용에 동의합니다.", isRequired: true, isAgreed: false)
    ])
    
    // MARK: - Init
    
    init(email: String, provider: String) {
        self.email = email
        self.provider = provider
    }
    
    // MARK: - Input
    
    struct Input {
        let checkNicknameDuplicate: PublishRelay<String>
        let nickname: BehaviorRelay<String>
    }
    
    // MARK: - Output
    
    struct Output {
        let email: BehaviorRelay<String>
        let consentList: BehaviorRelay<[ConsentModel]>
        let nicknameValidationResult: Driver<NicknameValidationState>
        let signUpButtonEnabled: Driver<Bool>
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

        // 회원가입 버튼 활성화 여부
        let signUpButtonEnabled = validationResult
            .map { state in
                if case .available = state {
                    return true
                }
                return false
            }

        return Output(
            email: BehaviorRelay(value: email),
            consentList: consentList,
            nicknameValidationResult: validationResult,
            signUpButtonEnabled: signUpButtonEnabled
        )
    }

    // MARK: - API Methods
    
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
}
