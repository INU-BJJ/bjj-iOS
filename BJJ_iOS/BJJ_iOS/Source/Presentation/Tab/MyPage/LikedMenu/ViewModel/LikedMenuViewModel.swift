//
//  LikedMenuViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import RxSwift
import RxCocoa

final class LikedMenuViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let fetchLikedMenuTrigger: Observable<Void>
        let toggleMenuLike: Observable<Int>
    }
    
    // MARK: - Ouptut
    
    struct Output {
        let likedMenuList: Observable<[LikedMenuSection]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {

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
                            // TODO: 토스트 메시지 띄우기
                            print("<< 좋아요 실패")
                            observer.onError(error)
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
        
        return Output(likedMenuList: likedMenuList)
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
}
