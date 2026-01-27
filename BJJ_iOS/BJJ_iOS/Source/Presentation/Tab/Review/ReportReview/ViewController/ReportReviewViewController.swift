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
    
    private let reportReviewButton = ConfirmButton(title: "신고하기")
    
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
            reportReviewButton
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
            $0.bottom.equalTo(reportReviewButton.snp.top).offset(-53)
        }
        
        reportReviewButton.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = ReportReviewViewModel.Input(
            itemSelected: reportTableView.rx.itemSelected.asDriver(),
            otherReasonText: reportOtherReasonTextView.rx.trimmedText,
            reportButtonTapped: reportReviewButton.rx.tap
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
        
        // 신고 버튼 활성화/비활성화
        output.reportButtonEnabled
            .drive(with: self, onNext: { owner, isEnabled in
                owner.reportReviewButton.setUI(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
        
        // 신고 결과 처리
        output.reportResult
            .drive(with: self, onNext: { owner, result in
                switch result {
                case .success:
                    // 신고 성공 시 이전 화면으로 이동
                    // TODO: 토스트 메세지
                    owner.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    // 신고 실패 시 에러 메시지 출력
                    print("[ReportReviewViewController] 신고 실패: \(error.localizedDescription)")
                    // TODO: 사용자에게 에러 알림 표시 (Alert 또는 Toast)
                }
            })
            .disposed(by: disposeBag)
    }
}
