//
//  BannerViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/26/26.
//

import RxSwift
import RxCocoa

final class BannerViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let bannerURI: String
    
    // MARK: - Init
    
    init(bannerURI: String) {
        self.bannerURI = baseURL.homepageURL + bannerURI
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
