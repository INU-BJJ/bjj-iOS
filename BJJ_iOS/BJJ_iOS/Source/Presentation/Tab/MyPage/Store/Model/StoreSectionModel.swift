//
//  StoreSectionModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/19/26.
//

import Foundation
import RxDataSources

struct StoreSectionModel {
    var header: ItemRarity
    var items: [StoreSection]
}

extension StoreSectionModel: SectionModelType {
    typealias Item = StoreSection

    init(original: StoreSectionModel, items: [StoreSection]) {
        self = original
        self.items = items
    }
}
