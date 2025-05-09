//
//  SeparatingLineView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import UIKit
import SnapKit
import Then

final class SeparatingLineView: UICollectionReusableView, ReuseIdentifying {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let dividerView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        addSubview(dividerView)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(snp.horizontalEdges)
            $0.height.equalTo(1)
        }
    }
    
    // MARK: - Configure LineView
    
    func configureLineView(_ style: LineStyle) {
        dividerView.backgroundColor = style.borderColor
        
        dividerView.snp.updateConstraints {
            $0.height.equalTo(style.borderWidth)
        }
    }
}
