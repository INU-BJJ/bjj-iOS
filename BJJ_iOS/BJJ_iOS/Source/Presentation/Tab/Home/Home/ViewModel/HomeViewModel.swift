//
//  HomeViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/25/26.
//

import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: PublishRelay<Void>
    }
    
    // MARK: - Output

    struct Output {
        let bannerList: Driver<[Banner]>
    }
    
    // MARK: - Transform

    func transform(input: Input) -> Output {
        // viewWillAppear 시 배너 리스트 조회
        let bannerList = input.viewWillAppear
            .flatMapLatest { [weak self] _ -> Observable<[Banner]> in
                guard let self = self else {
                    return Observable.just([])
                }
                return self.fetchBannerList()
            }
            .asDriver(onErrorJustReturn: [])

        return Output(bannerList: bannerList)
    }

    // MARK: - API Methods

    /// 배너 리스트 조회
    private func fetchBannerList() -> Observable<[Banner]> {
        return Observable.create { observer in
            HomeAPI.fetchBannerList { result in
                switch result {
                case .success(let bannerDTOList):
                    let banners = bannerDTOList.map { dto in
                        Banner(
                            image: dto.imageName,
                            uri: dto.pageUri
                        )
                    }
                    observer.onNext(banners)
                    observer.onCompleted()

                case .failure(let error):
                    print("[HomeViewModel] fetchBannerList Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
}
