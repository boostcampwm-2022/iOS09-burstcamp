//
//  FeedDetailViewModel.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Foundation

enum FeedDetailViewModelError: LocalizedError {
    case feedIsNil
}

extension FeedDetailViewModelError {
    var errorDescription: String? {
        switch self {
        case .feedIsNil: return "해당하는 Feed가 없습니다."
        }
    }
}
