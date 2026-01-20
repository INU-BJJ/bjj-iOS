//
//  GachaResultViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/20/26.
//

import RxSwift
import RxCocoa

final class GachaResultViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private let itemType: ItemType
    
    // MARK: - Init
    
    init(itemType: ItemType) {
        self.itemType = itemType
    }
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
