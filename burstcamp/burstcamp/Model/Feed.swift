//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed {
    let feedUUID: String
    let writerUUID: String
    let feedTitle: Int
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let scrapUserUUIDs: [String]
}

struct MyUser {
    let userUUID: String
    let nickname: String
    let profileImageURL: String
    let domain: Domain
    let camperID: String
    let ordinalNumber: Int
    let blogURL: String
    let blogTitle: String
    let scrapFeedUUIDs: [String]
    let signupDate: Date
    let isPushOn: Bool
}
