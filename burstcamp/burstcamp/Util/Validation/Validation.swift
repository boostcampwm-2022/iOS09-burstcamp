//
//  Validation.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import Foundation

struct Validation {
    static func validate(nickname: String) -> Bool {
        return nickname.isEmpty ? false : true
    }

    static func validate(camperID: String) -> Bool {
        return camperID.count == 3 ? true : false
    }

    static func validate(blogLink: String) -> Bool {
        if blogLink.range(
            of: URLRegularExpression.tistory,
            options: .regularExpression
        ) != nil {
            return true
        } else if blogLink.range(
            of: URLRegularExpression.velog,
            options: .regularExpression
        ) != nil {
            return true
        }
        return false
    }

    static func validateIsEmpty(blogLink: String) -> Bool {
        if blogLink.isEmpty { return true }
        if blogLink.range(
            of: URLRegularExpression.tistory,
            options: .regularExpression
        ) != nil {
            return true
        } else if blogLink.range(
            of: URLRegularExpression.velog,
            options: .regularExpression
        ) != nil {
            return true
        }
        return false
    }
}
