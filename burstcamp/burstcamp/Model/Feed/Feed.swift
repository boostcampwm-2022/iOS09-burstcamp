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
}

extension Feed {
    init(
        feedAPIModel: FeedAPIModel,
        feedWriter: FeedWriter,
        scrapCount: Int = 0,
        isScraped: Bool = false
    ) {
        self.feedUUID = feedAPIModel.feedUUID
        self.writer = feedWriter
        self.title = feedAPIModel.title
        self.pubDate = feedAPIModel.pubDate
        self.url = feedAPIModel.url
        self.thumbnailURL = feedAPIModel.thumbnailURL
        self.content = feedAPIModel.content
        self.scrapCount = scrapCount
        self.isScraped = isScraped
    }
}

extension Feed: RealmConvertible {
    init(realmModel: FeedRealmModel) {
        self.feedUUID = realmModel.feedUUID
        self.writer = FeedWriter(realmModel: realmModel.writer)
        self.title = realmModel.title
        self.pubDate = realmModel.pubDate
        self.url = realmModel.url
        self.thumbnailURL = realmModel.thumbnailURL
        self.content = realmModel.content
        self.scrapCount = realmModel.scrapCount
        self.isScraped = realmModel.isScraped
    }

    func realmModel() -> FeedRealmModel {
        return FeedRealmModel(
            feedUUID: self.feedUUID,
            writer: self.writer.realmModel(),
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: self.scrapCount,
            isScraped: self.isScraped
        )
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
    }

    mutating func unScrap() {
        if scrapCount > 0 {
            scrapCount -= 1
        }
        isScraped = false
    }
}
