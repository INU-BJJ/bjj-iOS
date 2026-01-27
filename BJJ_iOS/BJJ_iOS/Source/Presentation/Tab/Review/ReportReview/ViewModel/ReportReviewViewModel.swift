//
//  ReportReviewViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import Foundation
import RxSwift
import RxCocoa

final class ReportReviewViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let reviewID: Int
    private let reportReasonList = BehaviorRelay(value: ReportReason.allCases.map { ReportReasonItem(reason: $0) })
    private let otherReasonText = BehaviorRelay<String>(value: "")
    
    // MARK: - Init
    
    init(reviewID: Int) {
        self.reviewID = reviewID
    }
    
    // MARK: - Input
    
    struct Input {
        let itemSelected: Driver<IndexPath>
        let otherReasonText: Driver<String>
        let reportButtonTapped: ControlEvent<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let reportReasonList: Driver<[ReportReasonItem]>
        let reportButtonEnabled: Driver<Bool>
        let reportResult: Driver<Result<Void, Error>>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        // 셀 탭 시 해당 인덱스의 isSelected 토글
        input.itemSelected
            .drive(with: self, onNext: { owner, indexPath in
                var items = owner.reportReasonList.value
                items[indexPath.row].isSelected.toggle()
                owner.reportReasonList.accept(items)
            })
            .disposed(by: disposeBag)
        
        // 기타 사유 텍스트 저장
        input.otherReasonText
            .drive(with: self, onNext: { owner, text in
                owner.otherReasonText.accept(text)
            })
            .disposed(by: disposeBag)

        // 신고 버튼 활성화 여부 (선택된 항목이 1개 이상이면 true)
        let reportButtonEnabled = reportReasonList
            .map { items in items.contains(where: { $0.isSelected }) }
            .asDriver(onErrorJustReturn: false)
        
        // 신고 버튼 탭 시 API 호출
        let reportResult = input.reportButtonTapped
            .asObservable()
            .withLatestFrom(Observable.combineLatest(
                reportReasonList.asObservable(),
                otherReasonText.asObservable())
            )
            .flatMapLatest { [weak self] (items, otherText) -> Observable<Result<Void, Error>> in
                guard let self = self else {
                    return Observable.just(.failure(NSError(domain: "ReportReviewViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "ViewModel이 해제되었습니다."])))
                }
                
                // 선택된 신고 사유
                let selectedReasons = items
                    .filter { $0.isSelected }
                    .map { $0.reason.rawValue }
                
                // 요청 body
                let reportReasons: [String: [String]] = [
                    "content": selectedReasons
                ]
                
                return self.postReportReview(reportReasons: reportReasons)
                    .map { .success(()) }
                    .catch { error in Observable.just(.failure(error)) }
            }
            .asDriver(onErrorJustReturn: .failure(NSError(domain: "ReportReviewViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 오류가 발생했습니다."])))
        
        return Output(
            reportReasonList: reportReasonList.asDriver(),
            reportButtonEnabled: reportButtonEnabled,
            reportResult: reportResult
        )
    }
}

// MARK: - API Methods

extension ReportReviewViewModel {
    
    /// 신고하기 post 요청
    private func postReportReview(reportReasons: [String: [String]]) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "ReportReviewViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "ViewModel이 해제되었습니다."]))
                return Disposables.create()
            }
            
            ReportReviewAPI.postReportReview(reviewID: self.reviewID, reportReasons: reportReasons) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("[Post ReportReviewAPI] Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
