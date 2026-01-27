//
//  BannerViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import UIKit
import SnapKit
import Then
import WebKit
import RxSwift
import RxCocoa

final class BannerViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: BannerViewModel
    
    // MARK: - Components
    
    private let bannerWebView = WKWebView().then {
        $0.scrollView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Init
    
    init(viewModel: BannerViewModel) {
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
        setBackNaviBar("이벤트")
    }

    // MARK: - Set Hierarchy

    override func setHierarchy() {
        view.addSubview(bannerWebView)
    }

    // MARK: - Set Constraints

    override func setConstraints() {
        bannerWebView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Bind
    
    override func bind() {
        let input = BannerViewModel.Input()
        let output = viewModel.transform(input: input)
        
        // 배너 웹뷰 로드
        output.bannerURI
            .bind(with: self, onNext: { owner, bannerURI in
                owner.loadWebView(uri: bannerURI)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
    
    private func loadWebView(uri: String) {
        guard let url = URL(string: uri) else {
            print("[BannerVC] Invalid URL: \(uri)")
            return
        }
        guard let token = KeychainManager.read(key: .accessToken) else {
            print("[BannerVC] accessToken not found")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        bannerWebView.load(request)
    }
}
