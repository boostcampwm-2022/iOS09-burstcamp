//
//  ErrorCategory.swift
//  burstcamp
//
//  Created by youtak on 2022/12/08.
//

import Foundation

protocol CategorizedError: Error {
    var category: ErrorCategory { get }
}

enum ErrorCategory {
    case retryable
    case nonRetryable
}
