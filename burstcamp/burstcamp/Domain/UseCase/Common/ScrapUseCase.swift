//
//  ScrapUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Foundation

protocol ScrapUseCase {
    func scrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed
    func unScrapFeed(_ feed: Feed, userUUID: String) async throws -> Feed
}
