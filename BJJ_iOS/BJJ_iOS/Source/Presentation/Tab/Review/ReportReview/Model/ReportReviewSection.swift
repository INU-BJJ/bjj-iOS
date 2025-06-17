//
//  ReportReviewSection.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/16/25.
//

import Foundation

enum ReportReason: String, CaseIterable {
    case irrelevant = "메뉴와 관련없는 내용"
    case inappropriate = "음란성, 욕설 등 부적절한 내용"
    case advertising = "부적절한 홍보 또는 광고"
    case unrelatedPhoto = "주문과 관련없는 사진 게시"
    case personalInfoLeak = "개인정보 유출 위험"
    case spamContent = "리뷰 작성 취지에 맞지 않는 내용(복사글 등)"
    case defamation = "누군가를 비방하는 내용"
    case other = "기타(하단 내용 작성)"
}
