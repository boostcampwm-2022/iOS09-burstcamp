//
//  FeedWriter+RealmCompatible.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmManager

extension FeedWriter: RealmCompatible {
    init(realmModel: FeedWriterRealmModel) {
        self.userUUID = realmModel.userUUID
        self.nickname = realmModel.nickname
        self.camperID = realmModel.camperID
        self.ordinalNumber = realmModel.ordinalNumber
        self.domain = realmModel.domain
        self.profileImageURL = realmModel.profileImageURL
        self.blogTitle = realmModel.blogTitle
    }

    func realmModel() -> FeedWriterRealmModel {
        return FeedWriterRealmModel(
            userUUID: self.userUUID,
            nickname: self.nickname,
            camperID: self.camperID,
            ordinalNumber: self.ordinalNumber,
            domain: self.domain,
            profileImageURL: self.profileImageURL,
            blogTitle: self.blogTitle
        )
    }

    enum PropertyValue: PropertyValueType {
        case userUUID(String)
        case nickname(String)
        case camperID(String)
        case ordinalNumber(Int)
        case domain(Domain)
        case profileImageURL(String)
        case blogTitle(String)

        var propertyValuePair: PropertyValuePair {
            switch self {
            case .userUUID(let userUUID):
                return ("userUUID", userUUID)
            case .nickname(let nickname):
                return ("nickname", nickname)
            case .camperID(let camperID):
                return ("camperID", camperID)
            case .ordinalNumber(let ordinalNumber):
                return ("ordinalNumber", ordinalNumber)
            case .domain(let domain):
                return ("domain", domain)
            case .profileImageURL(let profileImageURL):
                return ("profileImageURL", profileImageURL)
            case .blogTitle(let blogTitle):
                return ("blogTitle", blogTitle)
            }
        }
    }

    enum Query: QueryType {
        var predicate: NSPredicate? {
            return nil
        }

        var sortDescriptors: [RealmManager.RealmSortDescriptor] {
            return []
        }
    }
}
