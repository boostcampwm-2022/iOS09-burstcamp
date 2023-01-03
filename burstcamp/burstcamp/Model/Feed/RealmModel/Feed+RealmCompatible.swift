//
//  Feed+RealmCompatible.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmManager

extension Feed: RealmCompatible {
    init(realmModel: FeedRealmModel) {
        self.feedUUID = realmModel.feedUUID
        self.writer = realmModel.writer.flatMap(FeedWriter.init(realmModel:)) ?? FeedWriter()
        self.title = realmModel.title
        self.pubDate = realmModel.pubDate
        self.url = realmModel.url
        self.thumbnailURL = realmModel.thumbnailURL
        self.content = realmModel.content
        self.scrapCount = realmModel.scrapCount
        self.isScraped = realmModel.isScraped
        self.scrapDate = realmModel.scrapDate
    }

    func realmModel() -> FeedRealmModel {
        let feedRealmModel = FeedRealmModel()
        feedRealmModel.feedUUID = self.feedUUID
        feedRealmModel.writer = self.writer.realmModel()
        feedRealmModel.title = self.title
        feedRealmModel.pubDate = self.pubDate
        feedRealmModel.url = self.url
        feedRealmModel.thumbnailURL = self.thumbnailURL
        feedRealmModel.content = self.content
        feedRealmModel.scrapCount = self.scrapCount
        feedRealmModel.isScraped = self.isScraped
        feedRealmModel.scrapDate = self.scrapDate ?? Date()
        return feedRealmModel
    }

    enum PropertyValue: PropertyValueType {
        case feedUUID(String)
        case writer(FeedWriterRealmModel)
        case title(String)
        case pubDate(Date)
        case url(String)
        case thumbnailURL(String)
        case content(String)
        case scrapCount(Int)
        case isScraped(Bool)
        case scrapDate(Date)

        var propertyValuePair: PropertyValuePair {
            switch self {
            case .feedUUID(let feedUUID):
                return ("feedUUID", feedUUID)
            case .writer(let writer):
                return ("writer", writer)
            case .title(let title):
                return ("title", title)
            case .pubDate(let pubDate):
                return ("pubDate", pubDate)
            case .url(let url):
                return ("url", url)
            case .thumbnailURL(let thumbnailURL):
                return ("thumbnailURL", thumbnailURL)
            case .content(let content):
                return ("content", content)
            case .scrapCount(let scrapCount):
                return ("scrapCount", scrapCount)
            case .isScraped(let isScraped):
                return ("isScraped", isScraped)
            case .scrapDate(let scrapDate):
                return ("scrapDate", scrapDate)
            }
        }
    }
}
