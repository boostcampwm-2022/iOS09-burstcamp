//
//  FeedRealmModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmManager
import RealmSwift

final class NormalFeedRealmModel: FeedRealmModel { }

final class RecommendFeedRealmModel: FeedRealmModel { }

final class ScrapFeedRealmModel: FeedRealmModel { }

class FeedRealmModel: Object {
    @Persisted(primaryKey: true) var feedUUID: String
    @Persisted var writer: FeedWriterRealmModel?
    @Persisted var title: String
    @Persisted var pubDate: Date
    @Persisted var url: String
    @Persisted var thumbnailURL: String
    @Persisted var content: String
    @Persisted var scrapCount: Int
    @Persisted var isScraped: Bool
    @Persisted var scrapDate: Date?

    func configure(model: Feed) {
        self.feedUUID = model.feedUUID
        self.writer = model.writer.realmModel()
        self.title = model.title
        self.pubDate = model.pubDate
        self.url = model.url
        self.thumbnailURL = model.thumbnailURL
        self.content = model.content
        self.scrapCount = model.scrapCount
        self.isScraped = model.isScraped
        self.scrapDate = model.scrapDate
    }
}
