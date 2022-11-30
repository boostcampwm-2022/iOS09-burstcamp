//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation
import Firebase

struct Feed {
    let feedUUID: String
    let writer: FeedWriter
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let scrapCount: Int

    init(feedDTO: FeedDTO, feedWriter: FeedWriter) {
        self.feedUUID = feedDTO.feedUUID
        self.writer = feedWriter
        self.feedTitle = feedDTO.feedTitle
        self.pubDate = feedDTO.pubDate
        self.url = feedDTO.url
        self.thumbnailURL = feedDTO.thumbnailURL
        self.content = feedDTO.content
        self.scrapCount = 0
    }

    init() {
        feedUUID = ""
        writer = FeedWriter()
        feedTitle = ""
        pubDate = Date()
        url = ""
        thumbnailURL = ""
        content = ""
        scrapCount = 0
    }
}

struct FeedWriter {
    let nickname: String
    let camperID: String
    let ordinalNumber: Int
    let domain: Domain

    init(data: [String: Any]) {
        let nickname = data["nickname"] as? String ?? ""
        let camperID = data["camperID"] as? String ?? ""
        let ordinalNumber = data["ordinalNumber"] as? Int ?? 0
        let domainString = data["domain"] as? String ?? ""
        let domain = Domain(rawValue: domainString) ?? Domain.iOS

        self.nickname = nickname
        self.camperID = camperID
        self.ordinalNumber = ordinalNumber
        self.domain = domain
    }

    init() {
        nickname = ""
        camperID = ""
        ordinalNumber = 7
        domain = .iOS
    }
}

struct FeedDTO {
    let feedUUID: String
    let writerUUID: String
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String

    init(data: [String: Any]) {
        let feedUUID = data["feedUUID"] as? String ?? ""
        let writerUUID = data["writerUUID"] as? String ?? ""
        let feedTitle = data["feedTitle"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        let pubDate = timeStampDate.dateValue()
        let url = data["url"] as? String ?? ""
        let thumbnailURL = data["thumbnailURL"] as? String ?? ""
        let content = data["content"] as? String ?? ""

        self.feedUUID = feedUUID
        self.writerUUID = writerUUID
        self.feedTitle = feedTitle
        self.pubDate = pubDate
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.content = content
    }
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
