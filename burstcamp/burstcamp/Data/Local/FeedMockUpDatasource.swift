//
//  FeedMockUpDatasource.swift
//  burstcamp
//
//  Created by youtak on 2023/01/31.
//

import Foundation

protocol FeedMockUpDataSource {
    func createMockUpRecommendFeedList(count: Int) -> [Feed]
}

final class DefaultFeedMockUpDataSource: FeedMockUpDataSource {

    func createMockUpRecommendFeedList(count: Int) -> [Feed] {
        if count >= 3 {
            return [createMockUpRecommendFeed1(), createMockUpRecommendFeed2(), createMockUpRecommendFeed3()]
        } else if count == 2 {
            return [createMockUpRecommendFeed1(), createMockUpRecommendFeed2()]
        } else if count == 1 {
            return [createMockUpRecommendFeed1()]
        } else {
            return []
        }
    }

    private func createMockUpRecommendFeed1() -> Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: FeedWriter.getBurcam(domain: .web),
            title: "버스트 캠프에 오신걸 환영해요 🥳",
            pubDate: Date(),
            url: "",
            thumbnailURL: "",
            content: "",
            scrapCount: 0,
            isScraped: false
        )
    }

    private func createMockUpRecommendFeed2() -> Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: FeedWriter.getBurcam(domain: .android),
            title: "캠퍼들의 블로그를 둘러보며 함께 성장해요 🔥",
            pubDate: Date(),
            url: "",
            thumbnailURL: "",
            content: "",
            scrapCount: 0,
            isScraped: false
        )
    }

    private func createMockUpRecommendFeed3() -> Feed {
        return Feed(
            feedUUID: UUID().uuidString,
            writer: FeedWriter.getBurcam(domain: .iOS),
            title: "Burstcamp! Burstcamp! Burstcamp!",
            pubDate: Date(),
            url: "",
            thumbnailURL: "",
            content: "",
            scrapCount: 0,
            isScraped: false
        )
    }
}
