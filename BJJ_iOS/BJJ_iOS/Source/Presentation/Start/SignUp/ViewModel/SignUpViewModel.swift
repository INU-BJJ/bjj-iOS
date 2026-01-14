//
//  SignUpViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import Foundation
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
    
    private var consentList = BehaviorRelay(value: [
        ConsentModel(title: "(필수) 만 14세 이상입니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 서비스 이용약관에 동의합니다.", isRequired: true, isAgreed: false),
        ConsentModel(title: "(필수) 개인정보 수집•이용에 동의합니다.", isRequired: true, isAgreed: false)
    ])
    private let isAllAgreedRelay = BehaviorRelay(value: false)
    
    // MARK: - Init
    
    init(email: String, provider: String) {
        self.email = email
        self.provider = provider
    }
    
    // MARK: - Input
    
    struct Input {
        let checkNicknameDuplicate: PublishRelay<String>
        let nickname: BehaviorRelay<String>
        let toggleAllAgreed: PublishRelay<Void>
        let consentItemTapped: ControlEvent<IndexPath>
    }
    
    // MARK: - Output
    
    struct Output {
        let email: BehaviorRelay<String>
        let consentList: BehaviorRelay<[ConsentModel]>
        let nicknameValidationResult: Driver<NicknameValidationState>
        let isAllAgreed: Driver<Bool>
        let signUpButtonEnabled: Driver<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // 전체 동의 토글
        input.toggleAllAgreed
            .withLatestFrom(isAllAgreedRelay)
            .subscribe(onNext: { [weak self] currentState in
                guard let self = self else { return }
                let newState = !currentState
                self.isAllAgreedRelay.accept(newState)

                // 모든 동의 항목을 새로운 상태로 업데이트
                var updatedConsents = self.consentList.value
                for index in updatedConsents.indices {
                    updatedConsents[index].isAgreed = newState
                }
                self.consentList.accept(updatedConsents)
            })
            .disposed(by: disposeBag)
        
        // 개별 약관 동의 토글
        input.consentItemTapped
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                var updatedConsents = self.consentList.value
                updatedConsents[indexPath.item].isAgreed.toggle()
                self.consentList.accept(updatedConsents)
            })
            .disposed(by: disposeBag)

        // consentList 변경 감지 -> 모든 항목이 동의되었는지 확인하여 isAllAgreedRelay 업데이트
        consentList
            .map { consents in
                consents.allSatisfy { $0.isAgreed }
            }
            .bind(to: isAllAgreedRelay)
            .disposed(by: disposeBag)

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

        // 전체 동의 상태를 Driver로 변환
        let isAllAgreedDriver = isAllAgreedRelay.asDriver()
        
        // 회원가입 버튼 활성화 여부 (닉네임 검증 성공 AND 전체 동의)
        let signUpButtonEnabled = Driver.combineLatest(validationResult, isAllAgreedDriver)
            .map { state, isAllAgreed in
                if case .available = state, isAllAgreed {
                    return true
                }
                return false
            }
        
        return Output(
            email: BehaviorRelay(value: email),
            consentList: consentList,
            nicknameValidationResult: validationResult,
            isAllAgreed: isAllAgreedDriver,
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
