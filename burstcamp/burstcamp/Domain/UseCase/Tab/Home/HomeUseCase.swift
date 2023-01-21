//
//  HomeUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/03.
//

import Foundation

protocol HomeUseCase {
    func fetchRecentHomeFeedList() async throws -> HomeFeedList
    func fetchMoreNormalFeed() async throws -> [Feed]
}
