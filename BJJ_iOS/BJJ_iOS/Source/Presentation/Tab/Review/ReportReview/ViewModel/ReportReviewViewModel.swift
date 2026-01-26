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
    
    // MARK: - Init
    
    init(reviewID: Int) {
        self.reviewID = reviewID
    }
    
    // MARK: - Input
    
    struct Input {
        let itemSelected: Driver<IndexPath>
    }
    
    // MARK: - Output
    
    struct Output {
        let reportReasonList: Driver<[ReportReasonItem]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        // 셀 탭 시 해당 인덱스의 isSelected 토글
        input.itemSelected
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                var items = self.reportReasonList.value
                items[indexPath.row].isSelected.toggle()
                self.reportReasonList.accept(items)
            })
            .disposed(by: disposeBag)
        
        return Output(
            reportReasonList: reportReasonList.asDriver()
        )
    }
//
//    // MARK: - Public Methods
//    
//    func getSelectedReasons() -> [String] {
//        return reportReasonList.value
//            .filter { $0.isSelected }
//            .map { $0.reason.rawValue }
//    }
}
