//
//  StoreViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/16/26.
//

import RxSwift
import RxCocoa

final class StoreViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let selectedTab = BehaviorRelay<ItemType>(value: .character)
    
    // MARK: - Input
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let characterTabTapped: Observable<Void>
        let backgroundTabTapped: Observable<Void>
        let itemSelected: ControlEvent<StoreSection>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: Observable<[StoreSectionModel]>
        let selectedTab: Observable<ItemType>
        let dismissToMyPage: Observable<Void>
    }
    
    // MARK: - Transform

    func transform(input: Input) -> Output {
        // 탭 선택 이벤트를 BehaviorRelay에 바인딩
        Observable.merge(
            input.characterTabTapped.map { ItemType.character },
            input.backgroundTabTapped.map { ItemType.background }
        )
        .bind(to: selectedTab)
        .disposed(by: disposeBag)

        // viewWillAppear 또는 탭 선택 시 아이템 새로고침
        let refreshTrigger = Observable.merge(
            input.viewWillAppear,
            selectedTab.map { _ in () }
        )

        // 선택된 탭에 따라 아이템 데이터 가져오기
        let items = refreshTrigger
            .withLatestFrom(selectedTab)
            .flatMapLatest { [weak self] itemType -> Observable<[StoreSectionModel]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                // 실제 API 호출
                return self.fetchAllItems(itemType: itemType)
            }
            .share(replay: 1)

        // 아이템 선택 시 PATCH 요청
        let dismissToMyPage = input.itemSelected
            .flatMapLatest { [weak self] item -> Observable<Void> in
                guard let self = self else {
                    return Observable.empty()
                }
                
                return self.patchItem(itemType: item.itemType.rawValue, itemID: item.itemID)
            }

        return Output(
            items: items,
            selectedTab: selectedTab.asObservable(),
            dismissToMyPage: dismissToMyPage
        )
    }

    // MARK: - API Methods

    /// 전체 아이템 정보 가져오기
    private func fetchAllItems(itemType: ItemType) -> Observable<[StoreSectionModel]> {
        return Observable.create { observer in
            StoreAPI.fetchAllItems(itemType: itemType) { result in
                switch result {
                case .success(let allItems):
                    let items = allItems.map { item -> StoreSection in
                        let type = ItemType(rawValue: item.itemType) ?? .character
                        let imageURL = type == .character
                              ? baseURL.characterImageURL + "dic_\(item.itemImage).svg"
                              : baseURL.backgroundImageURL + "\(item.itemImage).svg"
                        
                        let rarity = ItemRarity(rawValue: item.itemRarity) ?? .default
                        
                        // default인 경우 "영구 보유", 그 외엔 validPeriod 계산
                        let validPeriodText: String?
                        if rarity == .default {
                            validPeriodText = "영구 보유"
                        } else {
                            validPeriodText = item.validPeriod.flatMap { DateFormatterManager.shared.calculateItemValidPeriod(from: $0) }
                        }

                        return StoreSection(
                            itemID: item.itemID,
                            itemName: item.itemName,
                            itemType: type,
                            itemRarity: rarity,
                            itemImage: imageURL,
                            validPeriod: validPeriodText,
                            isWearing: item.isWearing,
                            isOwned: item.isOwned
                        )
                    }

                    // ItemRarity별로 섹션 모델 생성
                    // default와 common은 "흔함" 섹션으로 통합
                    let sections: [StoreSectionModel] = [ItemRarity.common, .normal, .rare]
                        .compactMap { rarity in
                            let filteredItems = items.filter {
                                if rarity == .common {
                                    // common 섹션에는 default와 common 아이템 모두 포함
                                    return $0.itemRarity == .default || $0.itemRarity == .common
                                } else {
                                    return $0.itemRarity == rarity
                                }
                            }
                            guard !filteredItems.isEmpty else { return nil }
                            return StoreSectionModel(header: rarity, items: filteredItems)
                        }

                    observer.onNext(sections)
                    observer.onCompleted()

                case .failure(let error):
                    print("[StoreViewModel] Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }
    
    /// 아이템 유효기간 갱신
    private func refreshItemsValidity(itemType: ItemType) -> Observable<[StoreSectionModel]> {
        return fetchAllItems(itemType: itemType)
    }
    
    /// 아이템 착용
    private func patchItem(itemType: String, itemID: Int) -> Observable<Void> {
        return Observable.create { observer in
            GachaResultAPI.patchItem(itemType: itemType, itemID: itemID) { result in
                switch result {
                case .success:
                    // 성공 시 화면 닫기 이벤트 방출
                    observer.onNext(())
                    observer.onCompleted()

                case .failure(let error):
                    // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                    // 에러가 발생해도 일단 화면 닫기 (임시 처리)
                    print("[StoreViewModel] Error: \(error.localizedDescription)")
                    observer.onNext(())
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}
