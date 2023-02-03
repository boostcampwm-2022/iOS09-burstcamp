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

    static let scrapFeedUUIDs = "scrapFeedUUIDs"
}

extension FirestoreCollection {

    var path: String {
        switch self {
        case .normalFeed: return "feed"
        case .recommendFeed: return "recommendFeed"
        case .user: return "user"
        case .scrapUsers(let feedUUID): return "feed/\(feedUUID)/scrapUsers"
        case .scrapFeeds(let userUUID): return "user/\(userUUID)/scrapFeeds"
        case .admin: return "admin"
        case .fcmToken: return "fcmToken"
        }
    }
}
