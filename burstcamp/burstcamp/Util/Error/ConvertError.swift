//
//  ConvertError.swift
//  burstcamp
//
//  Created by youtak on 2022/12/07.
//

import Foundation

enum ConvertError: LocalizedError {
    case dictionaryUnwrappingError

    var errorDescription: String? {
        switch self {
        case .dictionaryUnwrappingError: return "딕셔너리 언래핑 중 에러가 발생했습니다."
        }
    }
}
