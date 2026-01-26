//
//  MyReviewMenuModalViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import Foundation
import RxSwift
import RxCocoa

final class MyReviewMenuModalViewModel: BaseViewModel {

    // MARK: - DisposeBag

    private let disposeBag = DisposeBag()

    // MARK: - Properties

    private let reviewID: Int

    // MARK: - Init
    
    init(reviewID: Int) {
        self.reviewID = reviewID
    }

    // MARK: - Input

    struct Input {
        let deleteButtonTapped: PublishRelay<Void>
    }

    // MARK: - Output

    struct Output {
        let deleteResult: Driver<Result<Void, Error>>
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        
        // 삭제 버튼 탭 시 API 호출
        let deleteResult = input.deleteButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return Observable.just(.failure(NSError(domain: "MyReviewMenuModalViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "리뷰 삭제 중 오류가 발생했습니다."])))
                }

                return self.deleteMyReview(reviewID: self.reviewID)
                    .map { .success(()) }
                    .catch { error in Observable.just(.failure(error)) }
            }
            .asDriver(onErrorJustReturn: .failure(NSError(domain: "MyReviewMenuModalViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 오류가 발생했습니다."])))

        return Output(deleteResult: deleteResult)
    }

    // MARK: - API Methods

    /// 리뷰 삭제
    private func deleteMyReview(reviewID: Int) -> Observable<Void> {
        return Observable.create { observer in
            MyReviewDetailAPI.deleteMyReview(reviewID: reviewID) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()

                case .failure(let error):
                    print("[MyReviewMenuModalViewModel] deleteMyReview Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
}
