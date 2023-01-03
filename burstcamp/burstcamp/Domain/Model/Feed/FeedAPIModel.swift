//
//  FeedAPIModel.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

import class FirebaseFirestore.Timestamp

struct FeedAPIModel {
    let feedUUID: String
    let writerUUID: String
    let title: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
}

extension FeedAPIModel {
    init(data: [String: Any]) {
        self.feedUUID = data["feedUUID"] as? String ?? ""
        self.writerUUID = data["writerUUID"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        self.pubDate = timeStampDate.dateValue()
        self.url = data["url"] as? String ?? ""
        self.thumbnailURL = data["thumbnail"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
    }
}
