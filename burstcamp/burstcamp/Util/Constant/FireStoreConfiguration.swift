//
//  FireStoreConfiguration.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

enum FireStoreCollection: String {
    case user = "user"
    case feed = "feed"
    case fcmToken = "FCMToken"
    case recommendFeed = "RecommendFeed"

    var path: String {
        return self.rawValue
    }
}
