//
//  FirestoreCollection.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

import FirebaseFirestore

enum FirestoreCollection {
    case feed
    case recommendFeed
    case user
    case scrapUser(feedUUID: String)
    case admin
    case fcmToken
}

extension FirestoreCollection {
    private static let database = Firestore.firestore()

    var path: String {
        switch self {

        case .feed: return "feed"
        case .recommendFeed: return "recommendFeed"
        case .user: return "user"
        case .scrapUser(let feedUUID): return "feed/\(feedUUID)/scrapUsers"
        case .admin: return "admin"
        case .fcmToken: return "FCMToken"
        }
    }

    var reference: CollectionReference {
        return FirestoreCollection.database.collection(path)
    }
}
