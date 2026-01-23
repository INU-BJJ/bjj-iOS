//
//  ServicePolicyViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/23/26.
//

import UIKit
import SnapKit
import Then
import WebKit

final class ServicePolicyViewController: BaseViewController {

    // MARK: - Components
    
    private let webView = WKWebView()
    
    // MARK: - Set UI
    
    override func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("서비스 이용약관")
        
//        webView.loadHTMLString(htmlString, baseURL: baseURL)
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
}
