//
//  ReviewWriteViewController.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/7/25.
//

import UIKit
import SnapKit
import Then

final class ReviewWriteViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
//    private lazy var reviewWriteCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: createLayout()
//    ).then {
//        $0.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
//        $0.delegate = self
//        $0.dataSource = self
//    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackNaviBar("리뷰 작성하기")
    }
    
    // MARK: - Set AddViews
    
    private func setAddView() {
        [
            
        ].forEach(view.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        
    }
    
    // MARK: - Create Layout
    
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            switch sectionIndex {
//            case 0:
//                return self.createCafeteriaSection()
//            case 1:
//                return self.createMenuSection()
//            default:
//                return nil
//            }
//        }
//    }
}
