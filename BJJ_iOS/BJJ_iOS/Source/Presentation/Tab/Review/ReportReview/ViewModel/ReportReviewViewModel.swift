//
//  ReportReviewViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import RxSwift
import RxCocoa

final class ReportReviewViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let reviewID: Int
    private let reportReasonList = BehaviorRelay(value: ReportReason.allCases)
    
    // MARK: - Init
    
    init(reviewID: Int) {
        self.reviewID = reviewID
    }
    
    // MARK: - Input
    
    struct Input {
        
    }
    
    // MARK: - Output
    
    struct Output {
        let reportReasonList: BehaviorRelay<[ReportReason]>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output(reportReasonList: reportReasonList)
    }
}
