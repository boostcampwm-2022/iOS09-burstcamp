//
//  FirestoreCollection.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

import FirebaseFirestore

enum FirestoreCollection {
    case user
    case feed
    case fcmToken
    case scrapUser(feedUUID: String)
    case recommendFeed
}

extension FirestoreCollection {
    private static let database = Firestore.firestore()

    private var path: String {
        switch self {
        case .user: return "user"
        case .feed: return "feed"
        case .fcmToken: return "FCMToken"
        case .scrapUser(let feedUUID): return "feed/\(feedUUID)/scrapUsers"
        case .recommendFeed: return "recommendFeed"
        }
    }

    var reference: CollectionReference {
        return FirestoreCollection.database.collection(path)
    }
}
