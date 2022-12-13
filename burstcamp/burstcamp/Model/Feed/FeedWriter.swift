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
        self.userUUID = data["userUUID"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.camperID = data["camperID"] as? String ?? ""
        self.ordinalNumber = data["ordinalNumber"] as? Int ?? 0
        let domainString = data["domain"] as? String ?? ""
        self.domain = Domain(rawValue: domainString) ?? Domain.iOS
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.blogTitle = data["blogTitle"] as? String ?? ""
    }
}
