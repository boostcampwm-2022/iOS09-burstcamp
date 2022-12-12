//
//  FeedWriter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

struct FeedWriter: Equatable {
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
        let userUUID = data["userUUID"] as? String ?? ""
        let nickname = data["nickname"] as? String ?? ""
        let camperID = data["camperID"] as? String ?? ""
        let ordinalNumber = data["ordinalNumber"] as? Int ?? 0
        let domainString = data["domain"] as? String ?? ""
        let domain = Domain(rawValue: domainString) ?? Domain.iOS
        let profileImageURL = data["profileImageURL"] as? String ?? ""
        let blogTitle = data["blogTitle"] as? String ?? ""

        self.userUUID = userUUID
        self.nickname = nickname
        self.camperID = camperID
        self.ordinalNumber = ordinalNumber
        self.domain = domain
        self.profileImageURL = profileImageURL
        self.blogTitle = blogTitle
    }
}
