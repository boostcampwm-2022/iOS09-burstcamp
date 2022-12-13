//
//  FeedRealmModel.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation
import RealmSwift

class FeedRealmModel: Object {
    @Persisted var feedUUID: String
    @Persisted var writer: FeedWriterRealmModel
    @Persisted var title: String
    @Persisted var pubDate: Date
    @Persisted var url: String
    @Persisted var thumbnailURL: String
    @Persisted var content: String
    @Persisted var scrapCount: Int
    @Persisted var isScraped: Bool
    @Persisted var scrapDate: Date

    init(
        feedUUID: String,
        writer: FeedWriterRealmModel,
        title: String,
        pubDate: Date,
        url: String,
        thumbnailURL: String,
        content: String,
        scrapCount: Int,
        isScraped: Bool,
        scrapDate: Date
    ) {
        self.feedUUID = feedUUID
        self.writer = writer
        self.title = title
        self.pubDate = pubDate
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.content = content
        self.scrapCount = scrapCount
        self.isScraped = isScraped
        self.scrapDate = scrapDate
    }
}
