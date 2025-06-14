//
//  ReviewPhotoGallerySection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/12/25.
//

import Foundation

// TODO: - 섹션, 아이템 이름 수정하기

enum ReviewPhotoGallerySection: Hashable {
    case reviewPhotos
}

enum ReviewPhotoGalleryItem: Hashable {
    case photoURL(String)
}
