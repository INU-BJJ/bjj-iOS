//
//  ReportReviewViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/15/25.
//

import UIKit
import SnapKit
import Then

final class ReportReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private let reviewID: Int
    private let reportReasons = ReportReason.allCases
    private var reportContent: Set<String> = []
    private let otherPrefix = ReportReason.other.rawValue
    
    // MARK: - UI Components
    
    private lazy var testReportReviewTableView = UITableView().then {
        $0.register(ReportReviewCell.self, forCellReuseIdentifier: ReportReviewCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.allowsMultipleSelection = true
    }
    
    private lazy var testReportOtherReasonTextView = UITextView().then {
        $0.setTextViewUI("", font: .pretendard_bold, size: 18, color: .black)
        $0.layer.borderColor = UIColor.customColor(.midGray).cgColor
        $0.layer.borderWidth = 1
        $0.isEditable = false
        $0.isSelectable = false
        $0.backgroundColor = .customColor(.dropDownGray)
        $0.delegate = self
    }
    
    private lazy var testReportReviewButton = UIButton().then {
        $0.backgroundColor = .customColor(.mainColor)
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapReportReviewButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    init(reviewID: Int) {
        self.reviewID = reviewID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            testReportReviewTableView,
            testReportOtherReasonTextView,
            testReportReviewButton
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        testReportReviewTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(400)
        }
        
        testReportOtherReasonTextView.snp.makeConstraints {
            $0.top.equalTo(testReportReviewTableView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(testReportReviewTableView)
            $0.bottom.equalToSuperview().inset(140)
        }
        
        testReportReviewButton.snp.makeConstraints {
            $0.top.equalTo(testReportOtherReasonTextView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - objc Functions
    
    @objc private func didTapReportReviewButton() {
        let reportContent = ["content": Array(reportContent)]
        
        postReportReview(reviewID: reviewID, reportReasons: reportContent)
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

// MARK: UITableView DataSource

extension ReportReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reportReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportReviewCell.reuseIdentifier, for: indexPath) as? ReportReviewCell else {
            return UITableViewCell()
        }
        let reason = reportReasons[indexPath.row]
        
        cell.selectionStyle = .none
        cell.configureCell(with: reason)
        
        return cell
    }
}

// MARK: - UITableView Delegate

extension ReportReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reasonString = reportReasons[indexPath.row].rawValue
        reportContent.insert(reasonString)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ReportReviewCell {
            cell.setSelected(true, animated: true)
        }
        updateOtherTextViewState()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let reasonString = reportReasons[indexPath.row].rawValue
        reportContent.remove(reasonString)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ReportReviewCell {
            cell.setSelected(false, animated: true)
        }
        updateOtherTextViewState()
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
