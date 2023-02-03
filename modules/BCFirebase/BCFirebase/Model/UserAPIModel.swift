//
//  UserAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

import class FirebaseFirestore.Timestamp

public struct UserAPIModel {
    public let userUUID: String
    public let nickname: String
    public let profileImageURL: String
    public let domain: String
    public let camperID: String
    public let ordinalNumber: Int
    public let blogURL: String
    public let blogTitle: String
    public var scrapFeedUUIDs: [String]
    public let signupDate: Date
    public let updateDate: Date
    public let isPushOn: Bool
}

extension UserAPIModel {
    public init(data: FirestoreData) {
        self.userUUID = data["userUUID"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.domain = data["domain"] as? String ?? ""
        self.camperID = data["camperID"] as? String ?? ""
        self.ordinalNumber = data["ordinalNumber"] as? Int ?? 7
        self.blogURL = data["blogURL"] as? String ?? ""
        self.blogTitle = data["blogTitle"] as? String ?? ""
        self.scrapFeedUUIDs = data["scrapFeedUUIDs"] as? [String] ?? []
        let timestampSignupDate = data["signupDate"] as? Timestamp ?? Timestamp()
        self.signupDate = timestampSignupDate.dateValue()
        let timestampUpdateDate = data["updateDate"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
        self.updateDate = timestampUpdateDate.dateValue()
        self.isPushOn = data["isPushOn"] as? Bool ?? false
    }

    public func toFirestoreData() -> FirestoreData {
        return [
            "userUUID": userUUID,
            "nickname": nickname,
            "profileImageURL": profileImageURL,
            "domain": domain,
            "camperID": camperID,
            "ordinalNumber": ordinalNumber,
            "blogURL": blogURL,
            "blogTitle": blogTitle,
            "scrapFeedUUIDs": scrapFeedUUIDs,
            "signupDate": Timestamp(date: signupDate),
            "updateDate": Timestamp(date: updateDate),
            "isPushOn": isPushOn
        ]
    }
}
