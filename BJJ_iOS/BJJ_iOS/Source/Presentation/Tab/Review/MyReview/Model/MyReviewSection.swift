//
//  MyReviewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 2/2/25.
//

import Foundation

struct MyReviewSection: Hashable {
    let reviewID: Int
    let reviewComment: String
    let reviewRating: Int
    let reviewImages: [String]?
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let menuPairID: Int
    let mainMenuName: String
    let subMenuName: String
    let memberID: Int
    let memberNickName: String
    let memberImageName: String?
}

struct MyReviews: Hashable {
    let studentCafeteriaReviews: [MyReviewSection]
    let staffCafeteriaReviews: [MyReviewSection]
}

// TODO: 더미 데이터 삭제
extension MyReviews {
    static let myReviews: MyReviews =
        MyReviews(
            studentCafeteriaReviews: [
                MyReviewSection(
                    reviewID: 1,
                    reviewComment: "굳굳",
                    reviewRating: 4,
                    reviewImages: nil,
                    reviewLikedCount: 111,
                    reviewCreatedDate: "2025.01.01",
                    menuPairID: 1,
                    mainMenuName: "고라니 구이",
                    subMenuName: "고라니 샐러드",
                    memberID: 1,
                    memberNickName: "고라니의 돌격",
                    memberImageName: nil
                )
            ],
            staffCafeteriaReviews: [
                MyReviewSection(
                    reviewID: 2,
                    reviewComment: "눋눋",
                    reviewRating: 3,
                    reviewImages: nil,
                    reviewLikedCount: 222,
                    reviewCreatedDate: "2025.02.02",
                    menuPairID: 2,
                    mainMenuName: "노라니 구이",
                    subMenuName: "노라니 샐러드",
                    memberID: 1,
                    memberNickName: "고라니의 돌격",
                    memberImageName: nil
                ),
                MyReviewSection(
                    reviewID: 3,
                    reviewComment: "둗둗",
                    reviewRating: 2,
                    reviewImages: nil,
                    reviewLikedCount: 333,
                    reviewCreatedDate: "2025.03.03",
                    menuPairID: 3,
                    mainMenuName: "도라니 구이",
                    subMenuName: "도라니 샐러드",
                    memberID: 1,
                    memberNickName: "고라니의 돌격",
                    memberImageName: nil
                )
            ]
        )
}
