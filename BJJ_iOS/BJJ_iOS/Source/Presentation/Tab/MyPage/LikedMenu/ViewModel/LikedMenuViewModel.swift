//
//  LikedMenuViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import RxSwift
import RxCocoa
import UserNotifications

final class LikedMenuViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let fetchLikedMenuTrigger: Observable<Void>
        let toggleMenuLike: Observable<Int>
        let viewWillAppear: Observable<Void>
        let sceneDidBecomeActive: Observable<Void>
        let likeNotifySwitchTapped: Observable<Bool>
    }
    
    // MARK: - Ouptut

    struct Output {
        let likedMenuList: Observable<[LikedMenuSection]>
        let errorMessage: Observable<String>
        let isNotificationAuthorized: Observable<Bool>
        let likeNotifySwitchState: Observable<Bool>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {

        // 에러 메시지 전달용 Relay
        let errorMessageRelay = PublishRelay<String>()
        
        // 알림 권한 상태 Relay
        let isNotificationAuthorizedRelay = BehaviorRelay<Bool>(value: true)
        
        // 스위치 상태 Relay
        let likeNotifySwitchStateRelay = BehaviorRelay<Bool>(value: false)
        
        // 좋아요 토글 후 재조회
        let toggledMenuList = input.toggleMenuLike
            .flatMapLatest { [weak self] menuID -> Observable<[LikedMenuSection]> in
                guard let self = self else {
                    return Observable.just([])
                }

                return Observable.create { observer in
                    MenuDetailAPI.postIsMenuLiked(menuID: menuID) { result in
                        switch result {
                        case .success:
                            // 성공 시 좋아요한 메뉴 재조회
                            self.fetchLikedMenu()
                                .bind(with: self, onNext: { owner, sections in
                                    observer.onNext(sections)
                                })
                                .disposed(by: self.disposeBag)

                        case .failure(let error):
                            // 좋아요 토글 실패 시 에러 메시지 방출
                            errorMessageRelay.accept(error.localizedDescription)
                            observer.onNext([])
                        }
                    }

                    return Disposables.create()
                }
            }

        // fetchLikedMenuTrigger 이벤트 발생 시 좋아요한 메뉴 가져오기
        let fetchedMenuList = input.fetchLikedMenuTrigger
            .flatMapLatest { [weak self] _ -> Observable<[LikedMenuSection]> in
                guard let self = self else {
                    return Observable.just([])
                }

                return self.fetchLikedMenu()
            }

        // 두 스트림 합치기
        let likedMenuList = Observable.merge(fetchedMenuList, toggledMenuList)
            .share(replay: 1)
        
        // TODO: 시스템에서 앱 알림 설정에 따라 likeNotifySwitch의 활성화 여부가 결정됨.
        // 시스템에서 앱 알림 설정을 활성화하면 알림 설정 fetch를 한 뒤 UI에 적용.
        // 시스템에서 앱 알림 설정을 비활성화하면 알림설정 patch API는 실행하지 않고 overlay 투명 버튼을 숨김 해제하고 likeNotifySwitch를 비활성화.
        // likeNotifySwitch는 오로지 API 알림 설정만 제어 가능.
        
        // viewWillAppear 또는 sceneDidBecomeActive 시 알림 권한 체크 및 스위치 상태 설정
        Observable.merge(input.viewWillAppear, input.sceneDidBecomeActive)
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return Observable.just(false)
                }
                return self.checkNotificationAuthorization()
            }
            .do(onNext: { isAuthorized in
                // 알림 권한 상태 업데이트
                isNotificationAuthorizedRelay.accept(isAuthorized)
                
                // 알림 권한이 꺼진 경우: 스위치를 무조건 OFF로 설정
                if !isAuthorized {
                    likeNotifySwitchStateRelay.accept(false)
                } else {
                    // TODO: [알림 설정 fetch API 연동 필요]
                    // 알림 권한이 있는 경우: 서버에서 알림 설정 상태를 fetch하여 UI에 적용
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
            
        // 스위치 탭 처리 (알림 권한이 있을 때만 호출됨)
        input.likeNotifySwitchTapped
            .flatMapLatest { [weak self] switchState -> Observable<Void> in
                guard let self = self else {
                    return Observable.just(())
                }

                // TODO: [알림 설정 patch API 연동 필요]
                // 서버에 알림 설정 변경 요청을 보내고 결과에 따라 스위치 상태 업데이트

                // 임시: 스위치 상태만 업데이트 (API 연동 전)
                likeNotifySwitchStateRelay.accept(switchState)
                
                /* API 연동 시 아래 코드 활성화
                return Observable.create { observer in
                    SettingAPI.patchNotifySetting { result in
                        switch result {
                        case .success:
                            // 스위치 상태 업데이트
                            likeNotifySwitchStateRelay.accept(switchState)
                            observer.onNext(())
                            observer.onCompleted()

                        case .failure(let error):
                            // 실패 시 에러 메시지 방출
                            errorMessageRelay.accept(error.localizedDescription)
                            // 스위치를 원래 상태로 되돌리기
                            likeNotifySwitchStateRelay.accept(!switchState)
                            observer.onNext(())
                            observer.onCompleted()
                        }
                    }

                    return Disposables.create()
                }
                */

                return Observable.just(())
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            likedMenuList: likedMenuList,
            errorMessage: errorMessageRelay.asObservable(),
            isNotificationAuthorized: isNotificationAuthorizedRelay.asObservable(),
            likeNotifySwitchState: likeNotifySwitchStateRelay.asObservable()
        )
    }

    // MARK: - API Methods
    
    /// 좋아요한 메뉴 정보 가져오기
    private func fetchLikedMenu() -> Observable<[LikedMenuSection]> {
        return Observable.create { observer in
            SettingAPI.fetchLikedMenu { result in
                switch result {
                case .success(let likedMenus):
                    let sections = likedMenus.map { menu -> LikedMenuSection in
                        LikedMenuSection(
                            menuID: menu.menuID,
                            menuName: menu.menuName
                        )
                    }
                    
                    observer.onNext(sections)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("[LikedMenuViewModel] Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Notification Methods
    
    /// 알림 권한 상태 체크
    private func checkNotificationAuthorization() -> Observable<Bool> {
        return Observable.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let isAuthorized = settings.authorizationStatus == .authorized
                observer.onNext(isAuthorized)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
