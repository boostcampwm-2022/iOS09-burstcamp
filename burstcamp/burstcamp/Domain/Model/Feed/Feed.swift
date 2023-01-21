//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed: Hashable {
    let feedUUID: String
    let writer: FeedWriter
    let title: String
    let pubDate: Date
    let url: String
    let thumbnailURL: String
    let content: String
    var scrapCount: Int
    var isScraped: Bool
    var scrapDate: Date?
}

extension Feed {
    init(
        feedAPIModel: FeedAPIModel,
        isScraped: Bool = false
    ) {
        self.feedUUID = feedAPIModel.feedUUID
        self.writer = FeedWriter(feedAPIModel: feedAPIModel)
        self.title = feedAPIModel.title
        self.pubDate = feedAPIModel.pubDate
        self.url = feedAPIModel.url
        self.thumbnailURL = feedAPIModel.thumbnailURL
        self.content = feedAPIModel.content
        self.scrapCount = feedAPIModel.scrapCount
        self.isScraped = isScraped
    }
}

extension Feed {
    mutating func toggleScrap() {
        isScraped ? unScrap() : scrap()
    }

    mutating func scrap() {
        scrapCount += 1
        isScraped = true
        scrapDate = Date()
    }

    mutating func unScrap() {
        if scrapCount > 0 {
            scrapCount -= 1
        }
        isScraped = false
        scrapDate = nil
    }

    func setIsScraped(_ isScraped: Bool) -> Feed {
        return Feed(
            feedUUID: self.feedUUID,
            writer: self.writer,
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: self.scrapCount,
            isScraped: isScraped
        )
    }
}
