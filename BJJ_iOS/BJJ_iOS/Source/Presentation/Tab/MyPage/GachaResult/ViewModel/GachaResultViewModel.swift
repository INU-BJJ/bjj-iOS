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
        let itemWearButtonTapped: ControlEvent<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let itemType: BehaviorRelay<[String]>
        let drawnItem: Driver<GachaResultModel>
        let itemImageURL: Driver<URL?>
        let itemTitle: Driver<String>
        let patchItemSuccess: Driver<Void>
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
        
        // 착용하기 버튼 탭 시 아이템 착용 API 호출
        let patchItemSuccess = input.itemWearButtonTapped
            .withLatestFrom(Observable.just(()))
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self,
                      let drawnItemInfo = self.drawnItemInfo else {
                    print("[GachaResultViewModel] Error: drawnItemInfo is nil")
                    return Observable.empty()
                }
                return self.patchItemWear(itemType: drawnItemInfo.itemType, itemID: drawnItemInfo.itemID)
            }
            .asDriver(onErrorJustReturn: ())

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
            itemTitle: itemTitle,
            patchItemSuccess: patchItemSuccess
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
    
    /// 아이템 착용 API 호출
    private func patchItemWear(itemType: String, itemID: Int) -> Observable<Void> {
        return Observable.create { observer in
            GachaResultAPI.patchItem(itemType: itemType, itemID: itemID) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                    
                case .failure(let error):
                    print("[GachaResultViewModel] patchItem Error: \(error.localizedDescription)")
                    // TODO: 빈 응답이라도 보내줘야됨. 현재는 아무 응답도 받지 못해서 Empty로도 디코딩하지 못하는것.
                    // 에러가 발생해도 성공으로 처리 (서버 응답 이슈)
                    observer.onNext(())
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}
