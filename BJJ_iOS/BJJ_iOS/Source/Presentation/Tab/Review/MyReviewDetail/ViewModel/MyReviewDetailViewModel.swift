//
//  MyReviewDetailViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import RxSwift
import RxCocoa

final class MyReviewDetailViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties

    var isOwned: Bool = false
    private let isOwnedRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Input
    
    struct Input {
        let reviewLikeButtonTapped: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let isOwned: Driver<Bool>
        let showOwnReviewAlert: Driver<Void>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        // isOwned 상태를 Driver로 변환
        let isOwnedDriver = isOwnedRelay.asDriver()
        
        // 좋아요 버튼 탭 시 isOwned가 true이면 알림 표시
        let showOwnReviewAlert = input.reviewLikeButtonTapped
            .withLatestFrom(isOwnedRelay.asObservable())
            .filter { $0 == true }
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())

        return Output(
            isOwned: isOwnedDriver,
            showOwnReviewAlert: showOwnReviewAlert
        )
    }
    
    // MARK: - Public Methods
    
    func updateIsOwned(_ value: Bool) {
        isOwned = value
        isOwnedRelay.accept(value)
    }
}
