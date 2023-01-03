//
//  FeedWriterRealmModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmSwift

class FeedWriterRealmModel: Object {
    @Persisted(primaryKey: true) var userUUID: String
    @Persisted var nickname: String
    @Persisted var camperID: String
    @Persisted var ordinalNumber: Int
    @Persisted var domain: Domain
    @Persisted var profileImageURL: String
    @Persisted var blogTitle: String

    convenience init(
        userUUID: String,
        nickname: String,
        camperID: String,
        ordinalNumber: Int,
        domain: Domain,
        profileImageURL: String,
        blogTitle: String
    ) {
        self.init()

        self.userUUID = userUUID
        self.nickname = nickname
        self.camperID = camperID
        self.ordinalNumber = ordinalNumber
        self.domain = domain
        self.profileImageURL = profileImageURL
        self.blogTitle = blogTitle
    }
}
