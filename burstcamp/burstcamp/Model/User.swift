//
//  User.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct User: Codable {
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
    init(
        userUUID: String,
        nickname: String,
        profileImageURL: String,
        domain: Domain,
        camperID: String,
        ordinalNumber: Int,
        blogURL: String,
        blogTitle: String,
        scrapFeedUUIDs: [String],
        signupDate: Date,
        isPushOn: Bool
    ) {
        self.userUUID = userUUID
        self.nickname = nickname
        self.profileImageURL = profileImageURL
        self.domain = domain
        self.camperID = camperID
        self.ordinalNumber = ordinalNumber
        self.blogURL = blogURL
        self.blogTitle = blogTitle
        self.scrapFeedUUIDs = scrapFeedUUIDs
        self.signupDate = signupDate
        self.isPushOn = isPushOn
    }
    
    init(dict: [String: Any]) {
        self.userUUID = dict["userUUID"] as? String ?? ""
        self.nickname = dict["nickname"] as? String ?? ""
        self.profileImageURL = dict["profileImageURL"] as? String ?? ""
        let domainString = dict["domain"] as? String ?? "iOS"
        self.domain = Domain(rawValue: domainString) ?? .iOS
        self.camperID = dict["camperID"] as? String ?? ""
        self.ordinalNumber = dict["ordinalNumber"] as? Int ?? 7
        self.blogURL = dict["blogURL"] as? String ?? ""
        self.blogTitle = dict["blogTitle"] as? String ?? ""
        self.scrapFeedUUIDs = dict["scrapFeedUUIDs"] as? [String] ?? []
        self.signupDate = dict["signupDate"] as? Date ?? Date() // TODO: Timestamp
        self.isPushOn = dict["isPushOn"] as? Bool ?? false
    }
}
