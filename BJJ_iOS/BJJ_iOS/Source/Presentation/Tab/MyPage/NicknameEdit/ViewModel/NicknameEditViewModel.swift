//
//  NicknameEditViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameEditViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let checkNicknameDuplicate: PublishRelay<String>
        let nickname: BehaviorRelay<String>
        let editNicknameButtonTapped: ControlEvent<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let nickname: Observable<String>
        let nicknameValidationResult: Driver<NicknameValidationState>
        let editNicknameButtonEnabled: Driver<Bool>
        let editNicknameResult: Driver<Result<String, Error>>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // viewDidLoad 시 현재 닉네임 조회
        let nickname = input.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { _ in return self.fetchNickname() }
        
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
        
        // 닉네임 변경 버튼 활성화 여부 (닉네임 검증 성공)
        let editNicknameButtonEnabled = validationResult
            .map { state in
                if case .available = state {
                    return true
                }
                return false
            }
        
        // 닉네임 변경 버튼 탭 -> API 호출
        let editNicknameResult = input.editNicknameButtonTapped
            .withLatestFrom(input.nickname)
            .flatMapLatest { [weak self] nickname -> Observable<Result<String, Error>> in
                guard let self = self else { return .empty() }
                return self.editNickname(nickname: nickname)
            }
            .asDriver(onErrorJustReturn: .failure(NSError(domain: "SignUpError", code: -1, userInfo: nil)))
        
        return Output(
            nickname: nickname,
            nicknameValidationResult: validationResult,
            editNicknameButtonEnabled: editNicknameButtonEnabled,
            editNicknameResult: editNicknameResult
        )
    }
    
    // MARK: - API Methods
    
    /// 닉네임 조회 API 요청
    private func fetchNickname() -> Observable<String> {
        return Observable.create { observer in
            MemberAPI.fetchMemberInfo { result in
                switch result {
                case .success(let memberInfo):
                    observer.onNext(memberInfo.nickname)
                    observer.onCompleted()

                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
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
    private func editNickname(nickname: String) -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            SettingAPI.patchNickname(nickname: nickname) { result in
                switch result {
                case .success:
                    observer.onNext(.success(nickname))
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

