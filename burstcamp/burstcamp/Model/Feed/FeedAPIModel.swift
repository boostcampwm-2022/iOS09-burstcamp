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
        let feedUUID = data["feedUUID"] as? String ?? ""
        let writerUUID = data["writerUUID"] as? String ?? ""
        let title = data["title"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        let pubDate = timeStampDate.dateValue()
        let url = data["url"] as? String ?? ""
        let thumbnailURL = data["thumbnail"] as? String ?? ""
        let content = data["content"] as? String ?? ""

        self.feedUUID = feedUUID
        self.writerUUID = writerUUID
        self.title = title
        self.pubDate = pubDate
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.content = content
    }
}
