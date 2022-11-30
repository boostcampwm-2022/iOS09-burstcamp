//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed {
    let feedUUID: String
    let writer: FeedWriter
    let feedTitle: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    let scrapCount: Int

    init(feedDTO: FeedDTO, feedWriter: FeedWriter) {
        self.feedUUID = feedDTO.feedUUID
        self.writer = feedWriter
        self.feedTitle = feedDTO.feedTitle
        self.pubDate = feedDTO.pubDate
        self.url = feedDTO.url
        self.thumbnailURL = feedDTO.thumbnailURL
        self.content = feedDTO.content
        self.scrapCount = 0
    }
}
