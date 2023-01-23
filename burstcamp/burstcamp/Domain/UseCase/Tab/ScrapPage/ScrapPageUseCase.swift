//
//  ScrapPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol ScrapPageUseCase {
    func fetchRecentScrapFeed() async throws -> [Feed]
    func fetchMoreScrapFeed() async throws -> [Feed]
    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed
}
