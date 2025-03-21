//
//  MenuDetailCollectionViewLayout.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 3/21/25.
//

import UIKit

final class MenuDetailCollectionViewLayout: UICollectionViewCompositionalLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.indexPath.section == 3 {
                layoutAttribute.zIndex = 1000   // ReviewCategorySelect 섹션을 가장 위로
            } else {
                layoutAttribute.zIndex = 0      // ReviewRating, ReviewContent, ReviewAddPhoto, ReviewGuidelines
            }
            
            // Footer zIndex 설정
            if layoutAttribute.representedElementKind == UICollectionView.elementKindSectionFooter {
                layoutAttribute.zIndex = 0
            }
        }
        
        return attributes
    }
}
