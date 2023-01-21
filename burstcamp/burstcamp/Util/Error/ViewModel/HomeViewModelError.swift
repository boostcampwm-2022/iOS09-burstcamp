//
//  HomeViewModelError.swift
//  burstcamp
//
//  Created by youtak on 2023/01/21.
//

import Foundation

enum HomeViewModelError: LocalizedError {
    case feedIndex
    case feedUpdate
}

extension HomeViewModelError {
    var errorDescription: String? {
        switch self {
        case .feedIndex: return "피드에 접근하는데 오류가 발생했습니다.(index)"
        case .feedUpdate: return "피드 업데이트하는데 오류가 발생했습니다."
        }
    }
}
