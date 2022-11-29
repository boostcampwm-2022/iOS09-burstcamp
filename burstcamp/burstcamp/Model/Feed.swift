//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed {
    let feedUUID: String
    let writerUUID: String
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let scrapUserUUIDs: [String]
}

struct MyUser {
    let userUUID: String
    let nickname: String
    let profileImageURL: String
    let domain: Domain
    let camperID: String
    let ordinalNumber: Int
    let blogURL: String
    let blogTitle: String
    let scrapFeedUUIDs: [String]
    let signupDate: Date
    let isPushOn: Bool
}

extension MyUser {
    static func mockUp() -> MyUser {
        return MyUser(
            userUUID: "youtakTest",
            nickname: "malcha",
            profileImageURL: "https://en.wikipedia.org/wiki/File:Steve_Jobs_Headshot_2010-CROP_(cropped_2).jpg",
            domain: .iOS,
            camperID: "S011",
            ordinalNumber: 7,
            blogURL: "https://malchafrappuccino.tistory.com/",
            blogTitle: "말차맛 개발 공부",
            scrapFeedUUIDs: [],
            signupDate: Date(),
            isPushOn: true
        )
    }
}
