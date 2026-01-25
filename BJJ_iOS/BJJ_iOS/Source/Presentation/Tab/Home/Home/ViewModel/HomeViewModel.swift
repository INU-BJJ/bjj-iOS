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
        let viewWillDisappear: PublishRelay<Void>
        let userDidScrollBanner: PublishRelay<Int>
    }
    
    // MARK: - Output

    struct Output {
        let bannerList: Driver<[Banner]>
        let scrollToIndex: Driver<Int>
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
            .map { banners -> [Banner] in
                // 무한 스크롤을 위해 앞뒤에 중복 아이템 추가
                // 원본: [1, 2, 3] → 변환: [3, 1, 2, 3, 1]
                guard banners.count > 0 else { return banners }
                
                var infiniteScrollBanners = banners
                if let last = banners.last {
                    infiniteScrollBanners.insert(last, at: 0) // 마지막 아이템을 맨 앞에 추가
                }
                if let first = banners.first {
                    infiniteScrollBanners.append(first) // 첫 번째 아이템을 맨 뒤에 추가
                }
                return infiniteScrollBanners
            }
            .asDriver(onErrorJustReturn: [])

        // 배너 개수를 추적
        let bannerCount = bannerList
            .map { $0.count }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        // 타이머: bannerCount가 emit될 때 시작
        let autoScrollTimer = bannerCount
            .filter { $0 > 1 }
            .flatMapLatest { _ -> Observable<Int> in
                return Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance)
                    .take(until: input.viewWillDisappear)
            }
        
        // 사용자 스크롤 시 타이머 재시작
        let userScrollRestart = input.userDidScrollBanner
            .withLatestFrom(bannerCount)
            .filter { $0 > 1 }
            .flatMapLatest { _ -> Observable<Int> in
                return Observable<Int>.interval(.seconds(10), scheduler: MainScheduler.instance)
                    .take(until: input.viewWillDisappear)
            }
        
        // 타이머 이벤트를 병합
        let timerEvents = Observable.merge(autoScrollTimer, userScrollRestart)
        
        // 현재 인덱스 계산 (타이머 이벤트마다 +1, 마지막이면 0으로)
        let scrollToIndex = timerEvents
            .withLatestFrom(bannerCount) { _, count in count }
            .scan(0) { currentIndex, count in
                let nextIndex = currentIndex + 1
                return nextIndex >= count ? 0 : nextIndex
            }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(
            bannerList: bannerList,
            scrollToIndex: scrollToIndex
        )
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
