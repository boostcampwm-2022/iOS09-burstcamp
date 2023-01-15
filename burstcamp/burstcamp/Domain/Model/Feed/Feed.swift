//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct Feed: Equatable {
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
        if isScraped { unScrap() }
        else { scrap() }
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
}

extension Feed {
    /// Mock Init
    init() {
        self.feedUUID = ""
        self.writer = FeedWriter()
        self.title = ""
        self.pubDate = Date(timeIntervalSince1970: 0)
        self.url = ""
        self.thumbnailURL = ""
        self.content = ""
        self.scrapCount = -1
        self.isScraped = false
    }
}
