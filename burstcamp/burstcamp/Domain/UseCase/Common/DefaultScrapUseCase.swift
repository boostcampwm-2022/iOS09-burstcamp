//
//  DefaultScrapUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Foundation

final class DefaultScrapUseCase: ScrapUseCase {

    private let feedRepository: FeedRepository

    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }

    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }

    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed {
        return try await feedRepository.scrapFeed(feed, userUUID: userUUID)
    }
}
