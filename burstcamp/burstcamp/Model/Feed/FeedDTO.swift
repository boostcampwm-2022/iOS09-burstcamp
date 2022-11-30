//
//  FeedDTO.swift
//  burstcamp
//
//  Created by youtak on 2022/11/30.
//

import Foundation

import Firebase

struct FeedDTO {
    let feedUUID: String
    let writerUUID: String
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String

    init(data: [String: Any]) {
        let feedUUID = data["feedUUID"] as? String ?? ""
        let writerUUID = data["writerUUID"] as? String ?? ""
        let feedTitle = data["feedTitle"] as? String ?? ""
        let timeStampDate = data["pubDate"] as? Timestamp ?? Timestamp()
        let pubDate = timeStampDate.dateValue()
        let url = data["url"] as? String ?? ""
        let thumbnailURL = data["thumbnailURL"] as? String ?? ""
        let content = data["content"] as? String ?? ""

        self.feedUUID = feedUUID
        self.writerUUID = writerUUID
        self.feedTitle = feedTitle
        self.pubDate = pubDate
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.content = content
    }
}
