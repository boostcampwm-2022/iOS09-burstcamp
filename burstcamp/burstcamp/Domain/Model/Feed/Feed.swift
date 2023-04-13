//
//  Feed.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

import BCFirebase

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
        self.title = feedAPIModel.title.changeEscapeString()
        self.pubDate = feedAPIModel.pubDate
        self.url = feedAPIModel.url
        self.thumbnailURL = feedAPIModel.thumbnailURL
        self.content = feedAPIModel.content
        self.scrapCount = feedAPIModel.scrapCount
        self.isScraped = isScraped
    }
}

extension Feed {
    func getScrapFeed() -> Feed {
        let newScrapCount = scrapCount + 1
        return Feed(
            feedUUID: self.feedUUID,
            writer: self.writer,
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: newScrapCount,
            isScraped: true,
            scrapDate: Date()
        )
    }

    func getUnScrapFeed() -> Feed {
        let newScrapCount = scrapCount - 1
        return Feed(
            feedUUID: self.feedUUID,
            writer: self.writer,
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: newScrapCount,
            isScraped: false,
            scrapDate: nil
        )
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

    func getMockUpFeed() -> Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: self.writer,
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
    func toFeedAPIModel() -> FeedAPIModel {
        return FeedAPIModel(
            feedUUID: self.feedUUID,
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: self.scrapCount,
            writerCamperID: self.writer.camperID,
            writerDomain: self.writer.domain.rawValue,
            writerNickname: self.writer.nickname,
            writerOrdinalNumber: self.writer.ordinalNumber,
            writerProfileImageURL: self.writer.profileImageURL,
            writerUUID: self.writer.userUUID,
            writerBlogTitle: self.writer.blogTitle
        )
    }

    func toScrapFeedAPIModel() -> ScrapFeedAPIModel {
        return ScrapFeedAPIModel(
            feedUUID: self.feedUUID,
            title: self.title,
            pubDate: self.pubDate,
            url: self.url,
            thumbnailURL: self.thumbnailURL,
            content: self.content,
            scrapCount: self.scrapCount,
            scrapDate: self.scrapDate ?? Date(),
            writerCamperID: self.writer.camperID,
            writerDomain: self.writer.domain.rawValue,
            writerNickname: self.writer.nickname,
            writerOrdinalNumber: self.writer.ordinalNumber,
            writerProfileImageURL: self.writer.profileImageURL,
            writerUUID: self.writer.userUUID,
            writerBlogTitle: self.writer.blogTitle
        )
    }
}
