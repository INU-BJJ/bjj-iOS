//
//  GachaResultViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/20/26.
//

import Foundation
import RxSwift
import RxCocoa

final class GachaResultViewModel: BaseViewModel {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let itemType: ItemType
    private var drawnItemInfo: GachaResultSection?
    
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
        let itemType: BehaviorRelay<[String]>
        let drawnItem: Driver<GachaResultModel>
        let itemImageURL: Driver<URL?>
        let itemTitle: Driver<String>
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        // viewDidLoad 시 뽑기 API 호출
        let drawnItem = input.viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<GachaResultModel> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.postItemGacha(itemType: self.itemType.rawValue)
            }
            .share(replay: 1)

        // 이미지 URL 생성
        let itemImageURL = drawnItem
            .map { itemInfo -> URL? in
                let baseURL = self.itemType == .character
                                ? baseURL.characterImageURL + "gacha_"
                                : baseURL.backgroundImageURL
                return URL(string: baseURL + itemInfo.itemImage + ".svg")
            }
            .asDriver(onErrorJustReturn: nil)
        
        // 타이틀 텍스트 생성
        let itemTitle = drawnItem
            .map { itemInfo in
                return "\(itemInfo.itemName) 등장!"
            }
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            itemType: BehaviorRelay(
                value: itemType == .character ? ["캐릭터를", "캐릭터는"] : ["배경을", "배경은"]
            ),
            drawnItem: drawnItem.asDriver(onErrorJustReturn: GachaResultModel(
                itemID: 0,
                itemName: "",
                itemType: "",
                itemRarity: "",
                itemImage: "",
                validPeriod: nil,
                isWearing: false,
                isOwned: false
            )),
            itemImageURL: itemImageURL,
            itemTitle: itemTitle
        )
    }
    
    // MARK: - API Methods
    
    /// 뽑기 API 호출
    private func postItemGacha(itemType: String) -> Observable<GachaResultModel> {
        return Observable.create { [weak self] observer in
            GachaResultAPI.postItemGacha(itemType: itemType) { result in
                switch result {
                case .success(let itemInfo):
                    // drawnItemInfo 저장 (착용하기 API 호출 시 사용)
                    self?.drawnItemInfo = GachaResultSection(
                        itemID: itemInfo.itemID,
                        itemType: itemInfo.itemType,
                        itemRarity: itemInfo.itemRarity
                    )
                    observer.onNext(itemInfo)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("[GachaResultViewModel] Error: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    // MARK: - Getter
    
    /// drawnItemInfo 가져오기 (착용하기 API 호출 시 사용)
    func getDrawnItemInfo() -> GachaResultSection? {
        return drawnItemInfo
    }
}
