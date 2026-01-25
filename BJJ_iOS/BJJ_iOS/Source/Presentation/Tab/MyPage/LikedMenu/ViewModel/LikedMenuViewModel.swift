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
    }
    
    // MARK: - Ouptut
    
    struct Output {
        let likedMenuList: Observable<[LikedMenuSection]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // fetchLikedMenuTrigger 이벤트 발생 시 좋아요한 메뉴 가져오기
        let likedMenuList = input.fetchLikedMenuTrigger
            .flatMapLatest { [weak self] _ -> Observable<[LikedMenuSection]> in
                guard let self = self else {
                    return Observable.just([])
                }

                return self.fetchLikedMenu()
            }
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
