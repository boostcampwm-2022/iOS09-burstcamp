//
//  Error+resolveCategory.swift
//  burstcamp
//
//  Created by youtak on 2022/12/08.
//

import Foundation

extension Error {
    func resolveCategory() -> ErrorCategory {
        guard let category = self as? CategorizedError else {
            return .nonRetryable
        }
        return category.category
    }
}
