//
//  FireStoreConfiguration.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

enum FireStoreCollection: String {
    case user = "User"
    case feed = "Feed"
    case fcmToken = "FCMToken"
    case scrapUser = "ScrapUser"
    case recommendFeed = "RecommendFeed"

    var path: String {
        return self.rawValue
    }
}
