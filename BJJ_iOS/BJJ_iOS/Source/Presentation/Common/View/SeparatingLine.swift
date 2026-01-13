//
//  SeparatingLine.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

import UIKit

final class SeparatingLine: UIView {

    init(color: UIColor = .D_9_D_9_D_9) {
        super.init(frame: .zero)
        
        backgroundColor = color
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
