//
//  UserAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

import class FirebaseFirestore.Timestamp

struct UserAPIModel {
    let userUUID: String
    let nickname: String
    let profileImageURL: String
    let domain: String
    let camperID: String
    let ordinalNumber: Int
    let blogURL: String
    let blogTitle: String
    // TODO: 지워야됨
    var scrapFeedUUIDs: [String]
    let signupDate: Date
    let isPushOn: Bool
}

extension UserAPIModel {
    init(data: FirestoreData) {
        self.userUUID = data["userUUID"] as? String ?? ""
        self.nickname = data["nickname"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.domain = data["domain"] as? String ?? ""
        self.camperID = data["camperID"] as? String ?? ""
        self.ordinalNumber = data["ordinalNumber"] as? Int ?? 7
        self.blogURL = data["blogURL"] as? String ?? ""
        self.blogTitle = data["blogTitle"] as? String ?? ""
        let timeStampDate = data["signupDate"] as? Timestamp ?? Timestamp()
        // TODO: 지워야됨
        self.scrapFeedUUIDs = data["scrapFeedUUIDs"] as? [String] ?? []
        self.signupDate = timeStampDate.dateValue()
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
            "signupDate": Timestamp(date: signupDate),
            "isPushOn": isPushOn
        ]
    }
}
