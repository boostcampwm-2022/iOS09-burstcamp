//
//  FirestoreCollection.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

import FirebaseFirestore

enum FirestoreCollection {
    case normalFeed
    case recommendFeed
    case user
    case scrapUsers(feedUUID: String)
    case scrapFeeds(userUUID: String)
    case admin
    case fcmToken
}

extension FirestoreCollection {
    // TODO: BeforeFirestore과 함께 삭제
    private static let database = Firestore.firestore()

    var path: String {
        switch self {
        case .normalFeed: return "feed"
        case .recommendFeed: return "recommendFeed"
        case .user: return "user"
        case .scrapUsers(let feedUUID): return "feed/\(feedUUID)/scrapUsers"
        case .scrapFeeds: return "user/\(UserManager.shared.user.userUUID)/scrapFeeds"
//        case .scrapFeeds(let userUUID): return "user/\(userUUID)/scrapFeeds"
        case .admin: return "admin"
        case .fcmToken: return "fcmToken"
        }
    }

    var reference: CollectionReference {
        return FirestoreCollection.database.collection(path)
    }
}
