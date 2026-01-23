//
//  PersonalPolicyViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import UIKit
import SnapKit
import Then
import WebKit
import RxSwift
import RxCocoa

final class PersonalPolicyViewController: BaseViewController {

    // MARK: - ViewModel
    
    private let viewModel = PersonalPolicyViewModel()
    
    // MARK: - Components
    
    private let webView = WKWebView()
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("개인정보 처리방침")
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        view.addSubview(webView)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = PersonalPolicyViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        // 개인정보 처리방침 웹뷰 로드
        output.personalPolicyHTML
            .drive(with: self) { owner, html in
                owner.webView.loadHTMLString(html, baseURL: URL(string: baseURL.URL))
            }
            .disposed(by: disposeBag)
    }
}
