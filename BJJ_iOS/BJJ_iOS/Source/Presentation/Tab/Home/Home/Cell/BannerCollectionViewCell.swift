//
//  BannerCollectionViewCell.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import UIKit
import SnapKit
import Then
import WebKit
import RxSwift

final class BannerCollectionViewCell: BaseCollectionViewCell<Banner> {

    // MARK: - Properties

    var disposeBag = DisposeBag()

    lazy var bannerTapGesture = UITapGestureRecognizer().then {
        $0.delegate = self
    }
    
    // MARK: - Components
    
    lazy var bannerWebView = WKWebView().then {
        $0.scrollView.isScrollEnabled = false
        $0.addGestureRecognizer(bannerTapGesture)
    }
    
    // MARK: - Reset
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    // MARK: - Set Hierarchy
    
    override func setHierarchy() {
        contentView.addSubview(bannerWebView)
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        bannerWebView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    
    override func configureCell(with data: Banner) {
        let svgURL = baseURL.bannerImageURL + data.image
        let html = createBannerHTML(with: svgURL)

        bannerWebView.loadHTMLString(html, baseURL: nil)
    }

    // MARK: - Create Banner HTML

    private func createBannerHTML(with url: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                }
                body {
                    width: 105vw;
                    height: 182px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    overflow: hidden;
                }
                img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
        </head>
        <body>
            <img src="\(url)" alt="Banner">
        </body>
        </html>
        """
    }
}

// MARK: - UIGestureRecognizer Delegate

extension BannerCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
