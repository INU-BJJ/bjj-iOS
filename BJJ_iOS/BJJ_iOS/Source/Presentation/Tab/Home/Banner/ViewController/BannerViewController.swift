//
//  BannerViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import UIKit
import SnapKit
import Then

final class BannerViewController: BaseViewController {
    
    // MARK: - ViewModel
    
    private let viewModel: BannerViewModel
    
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
}
