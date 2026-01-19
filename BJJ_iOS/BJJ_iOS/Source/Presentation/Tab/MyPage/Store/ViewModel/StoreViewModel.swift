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
    
    // MARK: - Dummy Data
    
    private let dummyData: [ItemType: [ItemRarity: [StoreSection]]] = {
        var data: [ItemType: [ItemRarity: [StoreSection]]] = [:]
        
        // 캐릭터 더미 데이터
        let characterCommon = (1...8).map { index in
            StoreSection(
                itemID: index,
                itemName: "흔한 캐릭터 \(index)",
                itemType: .character,
                itemRarity: .common,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "7d" : nil,
                isWearing: true,
                isOwned: index % 3 == 0
            )
        }

        let characterNormal = (101...108).map { index in
            StoreSection(
                itemID: index,
                itemName: "보통 캐릭터 \(index - 100)",
                itemType: .character,
                itemRarity: .normal,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "21h" : nil,
                isWearing: false,
                isOwned: index % 3 == 0
            )
        }

        let characterRare = (201...208).map { index in
            StoreSection(
                itemID: index,
                itemName: "희귀 캐릭터 \(index - 200)",
                itemType: .character,
                itemRarity: .rare,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "50m" : nil,
                isWearing: false,
                isOwned: index % 3 == 0
            )
        }

        data[.character] = [
            .common: characterCommon,
            .normal: characterNormal,
            .rare: characterRare
        ]

        // 배경 더미 데이터
        let backgroundCommon = (1001...1008).map { index in
            StoreSection(
                itemID: index,
                itemName: "흔한 배경 \(index - 1000)",
                itemType: .background,
                itemRarity: .common,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "1d" : nil,
                isWearing: false,
                isOwned: index % 3 == 0
            )
        }

        let backgroundNormal = (1101...1108).map { index in
            StoreSection(
                itemID: index,
                itemName: "보통 배경 \(index - 1100)",
                itemType: .background,
                itemRarity: .normal,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "21h" : nil,
                isWearing: false,
                isOwned: index % 3 == 0
            )
        }

        let backgroundRare = (1201...1208).map { index in
            StoreSection(
                itemID: index,
                itemName: "희귀 배경 \(index - 1200)",
                itemType: .background,
                itemRarity: .rare,
                itemImage: "placeholder",
                validPeriod: index % 2 == 0 ? "50m" : nil,
                isWearing: false,
                isOwned: index % 3 == 0
            )
        }

        data[.background] = [
            .common: backgroundCommon,
            .normal: backgroundNormal,
            .rare: backgroundRare
        ]

        return data
    }()

    // MARK: - Input
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let characterTabTapped: Observable<Void>
        let backgroundTabTapped: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: Observable<[ItemRarity: [StoreSection]]>
        let selectedTab: Observable<ItemType>
    }
    
    // MARK: - Transform

    func transform(input: Input) -> Output {
        // 선택된 탭 스트림 생성
        let selectedTab = Observable.merge(
            input.viewDidLoad.map { ItemType.character },
            input.characterTabTapped.map { ItemType.character },
            input.backgroundTabTapped.map { ItemType.background }
        )

        // 선택된 탭에 따라 아이템 데이터 변환
        let items = selectedTab
            .map { [weak self] itemType -> [ItemRarity: [StoreSection]] in
                return self?.dummyData[itemType] ?? [:]
            }

        return Output(
            items: items,
            selectedTab: selectedTab
        )
    }
}
