//
//  ReportReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/15/25.
//

import UIKit
import SnapKit
import Then

final class ReportReviewViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: ReportReviewViewModel
    
    // MARK: - Properties
    
    private var reportContent: Set<String> = []
    private let otherPrefix = ReportReason.other.rawValue
    
    // MARK: - UI Components
    
    private let reportTitleLabel = UILabel().then {
        $0.setLabel("리뷰를 신고하는 이유를 알려주세요!", font: .pretendard_bold, size: 15, color: .black)
    }
    
    private let reportGuideLabel = UILabel().then {
        $0.setLabel("타당한 근거 없이 신고된 내용은 관리자 확인 후 반영되지\n않을 수 있습니다.", font: .pretendard_medium, size: 13, color: ._999999)
        $0.numberOfLines = 2
    }
    
    private let reportTableView = UITableView().then {
        $0.register(ReportReviewCell.self, forCellReuseIdentifier: ReportReviewCell.reuseIdentifier)
        $0.separatorStyle = .none
        $0.allowsMultipleSelection = true
    }
    
    private lazy var reportOtherReasonTextView = PlaceholderTextView(
        placeholder: "신고하신 이유를 적어주세요.",
        maxLength: 500,
        hasIndicator: true
    )
    
    private lazy var testReportReviewButton = UIButton().then {
        $0.backgroundColor = .customColor(.mainColor)
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapReportReviewButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    init(viewModel: ReportReviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setXNaviBar("리뷰 신고하기")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        [
            reportTitleLabel,
            reportGuideLabel,
            reportTableView,
            reportOtherReasonTextView,
            testReportReviewButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        reportTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        reportGuideLabel.snp.makeConstraints {
            $0.top.equalTo(reportTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(reportTitleLabel)
        }
        
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(reportGuideLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(27)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(reportOtherReasonTextView.snp.top).offset(-10)
        }
        
        reportOtherReasonTextView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(158)
            $0.bottom.equalTo(testReportReviewButton.snp.top).offset(-53)
        }
        
        testReportReviewButton.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = ReportReviewViewModel.Input(
            itemSelected: reportTableView.rx.itemSelected.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        // 신고 사유 tableView 데이터 바인딩
        output.reportReasonList
            .drive(reportTableView.rx.items(
                cellIdentifier: ReportReviewCell.reuseIdentifier,
                cellType: ReportReviewCell.self)
            ) { index, reportReasonItem, cell in
                cell.configureCell(with: reportReasonItem)
            }
            .disposed(by: disposeBag)
        
//        // reportContent 동기화
//        output.reportReasonList
//            .map { items in
//                Set(items.filter { $0.isSelected }.map { $0.reason.rawValue })
//            }
//            .drive(onNext: { [weak self] selectedReasons in
//                self?.reportContent = selectedReasons
//                self?.updateOtherTextViewState()
//            })
//            .disposed(by: disposeBag)
    }
    
    // MARK: - objc Functions
    
    @objc private func didTapReportReviewButton() {
//        let selectedReasons = viewModel.getSelectedReasons()
//        let reportContent = ["content": selectedReasons]

//        postReportReview(reviewID: reviewID, reportReasons: reportContent)
    }
    
    // MARK: - Post API
    
    private func postReportReview(reviewID: Int, reportReasons: [String: [String]]) {
        ReportReviewAPI.postReportReview(reviewID: reviewID, reportReasons: reportReasons) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                print("[Post ReportReviewAPI] Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Update OtherTextView State
    
    private func updateOtherTextViewState() {
        let enabled = reportContent.contains { $0.hasPrefix(otherPrefix) }
        
        if !enabled { testReportOtherReasonTextView.text = "" }
        testReportOtherReasonTextView.isEditable = enabled
        testReportOtherReasonTextView.isSelectable = enabled
        testReportOtherReasonTextView.backgroundColor = enabled ? UIColor.white : UIColor.customColor(.dropDownGray)
    }
}

// MARK: - UITextView Delegate

extension ReportReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        reportContent = reportContent.filter { !$0.hasPrefix(otherPrefix) }
        
        let trimmedContent = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullContent = trimmedContent.isEmpty ? otherPrefix : "\(otherPrefix): \(trimmedContent)"
        
        reportContent.insert(fullContent)
    }
}
