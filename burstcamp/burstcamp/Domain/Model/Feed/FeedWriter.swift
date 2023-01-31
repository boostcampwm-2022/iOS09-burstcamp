//
//  FeedWriter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

struct FeedWriter: Hashable {
    let userUUID: String
    let nickname: String
    let camperID: String
    let ordinalNumber: Int
    let domain: Domain
    let profileImageURL: String
    let blogTitle: String
}

extension FeedWriter {
    init(data: [String: Any]) {
        self.userUUID = data["userUUID"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.camperID = data["camperID"] as? String ?? ""
        self.ordinalNumber = data["ordinalNumber"] as? Int ?? 0
        let domainString = data["domain"] as? String ?? ""
        self.domain = Domain(rawValue: domainString) ?? Domain.iOS
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.blogTitle = data["blogTitle"] as? String ?? ""
    }

    init(feedAPIModel: FeedAPIModel) {
        self.userUUID = feedAPIModel.writerUUID
        self.nickname = feedAPIModel.writerNickname
        self.camperID = feedAPIModel.writerCamperID
        self.ordinalNumber = feedAPIModel.writerOrdinalNumber
        let domainString = feedAPIModel.writerDomain
        self.domain = Domain(rawValue: domainString) ?? Domain.iOS
        self.profileImageURL = feedAPIModel.writerProfileImageURL
        self.blogTitle = feedAPIModel.writerBlogTitle
    }
}

extension FeedWriter {
    /// Mock Init
    init() {
        self.userUUID = ""
        self.nickname = ""
        self.camperID = ""
        self.ordinalNumber = 0
        self.domain = .iOS
        self.profileImageURL = ""
        self.blogTitle = ""
    }

    static func getBurcam(domain: Domain) -> FeedWriter {
        return FeedWriter(
            userUUID: UUID().uuidString,
            nickname: "버캠이",
            camperID: "",
            ordinalNumber: 7,
            domain: .iOS,
            profileImageURL: "",
            blogTitle: "버스트캠프 운영진"
        )
    }
}
