//
//  MenuItem.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 11/4/24.
//

import Foundation

struct MenuDetailModel: Hashable {
    let reviewComment: String
    let reviewRating: Int
    let reviewImage: String
    let reviewLikedCount: Int
    let reviewCreatedDate: String
    let mainMenuName: String
    let subMenuName: String
    let memberNickname: String
    let memberImage: String
    let isMemberLikedReview: Bool
}

struct ReviewListItem {
    let reviewList: [Review]
}

struct Review {
    let menu: MenuItem
    let menuReviewList: [MenuReviewInfo]
}

struct MenuItem {
    let menuName: String
    let menuImage: String
    let menuPrice: String
    let menuLiked: Bool
    let menuComposition: [String]
}

struct MenuReviewInfo {
    let userInfo: UserInfo
    let menuRating: Double
    let reviewDate: String
    let menuLikedCount: Int
    let reviewContent: String
    let reviewImage: [String]
}

struct UserInfo {
    let profileImage: String
    let nickname: String
}

extension ReviewListItem {
    static let reviewListData =
        ReviewListItem(
            reviewList:
                [
                    Review(
                        menu: MenuItem(
                                menuName: "양상추샐러드/복숭아아이스티1",
                                menuImage: "MenuImage1",
                                menuPrice: "5,500원",
                                menuLiked: true,
                                menuComposition: ["돼지불고기카레", "우동 국물", "찹쌀탕수육", "짜장떡볶이", "깍둑단무지무침", "배추김치", "기장밥"]),
                        menuReviewList:
                            [
                                MenuReviewInfo(
                                    userInfo:
                                        UserInfo(
                                            profileImage: "profile1",
                                            nickname: "떡볶이킬러나는최고야룰루"
                                        ),
                                    menuRating: 5.0,
                                    reviewDate: "2024.08.20",
                                    menuLikedCount: 0,
                                    reviewContent: "핫도그는 냉동인데\n떡볶이는 맛있음\n맛도 있고 가격도 착해서 떡볶이 땡길 때 추천",
                                    reviewImage: ["MenuImage1", "MenuImage2", "MenuImage1", "MenuImage2"]
                                ),
                                MenuReviewInfo(
                                    userInfo:
                                        UserInfo(
                                            profileImage: "profile2",
                                            nickname: "파괴전차 권효택"
                                        ),
                                    menuRating: 0.1,
                                    reviewDate: "2025.12.31",
                                    menuLikedCount: 99,
                                    reviewContent: "나를 사로잡은 그 맛",
                                    reviewImage: ["MenuImage1", "MenuImage2", "MenuImage1"]
                                )
                            ]
                    ),
                    Review(
                        menu: MenuItem(
                                menuName: "양상추샐러드/복숭아아이스티2",
                                menuImage: "MenuImage1",
                                menuPrice: "5,500원",
                                menuLiked: true,
                                menuComposition: ["우동 국물", "새우까스*칠리s", "쫄면", "단무지"]),
                        menuReviewList:
                            [
                                MenuReviewInfo(
                                    userInfo:
                                        UserInfo(
                                            profileImage: "profile3",
                                            nickname: "떡볶이킬러나는최고야룰루"
                                        ),
                                    menuRating: 5.0,
                                    reviewDate: "2024.08.20",
                                    menuLikedCount: 0,
                                    reviewContent: "핫도그는 냉동인데\n떡볶이는 맛있음\n맛도 있고 가격도 착해서 떡볶이 땡길 때 추천",
                                    reviewImage: ["MenuImage1", "MenuImage2", "MenuImage1", "MenuImage2", "MenuImage1"]
                                ),
                                MenuReviewInfo(
                                    userInfo:
                                        UserInfo(
                                            profileImage: "profile4",
                                            nickname: "파괴전차 권효택"
                                        ),
                                    menuRating: 0.1,
                                    reviewDate: "2025.12.31",
                                    menuLikedCount: 99,
                                    reviewContent: "나를 사로잡은 그 맛",
                                    reviewImage: ["MenuImage1", "MenuImage2", "MenuImage1"]
                                )
                            ]
                    )
                ]
        )
}
