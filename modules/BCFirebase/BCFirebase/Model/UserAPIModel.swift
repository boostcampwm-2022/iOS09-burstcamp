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
    public var reportFeedUUIDs: [String]
    public let signupDate: Date
    public let updateDate: Date
    public let isPushOn: Bool
    
    public init(userUUID: String,
                nickname: String,
                profileImageURL: String,
                domain: String,
                camperID: String,
                ordinalNumber: Int,
                blogURL: String,
                blogTitle: String,
                scrapFeedUUIDs: [String],
                reportFeedUUIDs: [String],
                signupDate: Date,
                updateDate: Date,
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
        self.reportFeedUUIDs = reportFeedUUIDs
        self.signupDate = signupDate
        self.updateDate = updateDate
        self.isPushOn = isPushOn
    }
}

public extension UserAPIModel {

    init(data: FirestoreData) {
        self.userUUID = data["userUUID"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.domain = data["domain"] as? String ?? ""
        self.camperID = data["camperID"] as? String ?? ""
        self.ordinalNumber = data["ordinalNumber"] as? Int ?? 7
        self.blogURL = data["blogURL"] as? String ?? ""
        self.blogTitle = data["blogTitle"] as? String ?? ""
        self.scrapFeedUUIDs = data["scrapFeedUUIDs"] as? [String] ?? []
        self.reportFeedUUIDs = data["reportFeedUUIDs"] as? [String] ?? []
        let timestampSignupDate = data["signupDate"] as? Timestamp ?? Timestamp()
        self.signupDate = timestampSignupDate.dateValue()
        let timestampUpdateDate = data["updateDate"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
        self.updateDate = timestampUpdateDate.dateValue()
        self.isPushOn = data["isPushOn"] as? Bool ?? false
    }

    func toFirestoreData() -> FirestoreData {
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
            "reportFeedUUIDs": reportFeedUUIDs,
            "signupDate": Timestamp(date: signupDate),
            "updateDate": Timestamp(date: updateDate),
            "isPushOn": isPushOn
        ]
    }
}
