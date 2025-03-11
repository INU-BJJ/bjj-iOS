//
//  MyReviewImageDetailViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/9/25.
//

import UIKit
import SnapKit
import Then

final class MyReviewImageDetailPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private var reviewImages: [String] = []
    private var currentIndex: Int = 0
    private var pages: [MyReviewImageDetailViewController] = []
    
    // MARK: - Init
    
    init(with reviewImages: [String], startIndex: Int = 0) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.reviewImages = reviewImages
        self.currentIndex = startIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setViewController()
        setScrollViewDelegate()
    }
    
    // MARK: - Set PageViewController
    
    private func setViewController() {
        self.dataSource = self
        self.delegate = self
        
        pages = reviewImages.map { MyReviewImageDetailViewController(reviewImage: $0) }
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    // MARK: - Set NavigationBAR
    
    private func setNavigationBar() {
        setClearWhiteBackTitleNaviBar("\(currentIndex + 1) / \(reviewImages.count)")
    }
    
    // MARK: - Set ScrollView Delegate
        
    private func setScrollViewDelegate() {
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break
            }
        }
    }
}

// MARK: - UIPageViewController DataSource

extension MyReviewImageDetailPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! MyReviewImageDetailViewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! MyReviewImageDetailViewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}

// MARK: - UIScrollView Delegate

extension MyReviewImageDetailPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentVC = viewControllers?.first as? MyReviewImageDetailViewController,
              let newIndex = pages.firstIndex(of: currentVC),
              newIndex != currentIndex else { return }

        currentIndex = newIndex
        setNavigationBar()
    }
}
