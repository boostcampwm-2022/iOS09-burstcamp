//
//  ScrapViewModelError.swift
//  burstcamp
//
//  Created by youtak on 2023/01/23.
//

import Foundation

enum ScrapPageViewModelError: LocalizedError {
    case scrapFeed
}

extension ScrapPageViewModelError {
    var errorDescription: String? {
        switch self {
        case .scrapFeed: return "피드를 스크랩 하는 중 오류가 발생했습니다."
        }
    }
}
