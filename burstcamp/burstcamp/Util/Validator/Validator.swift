//
//  Validator.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import Foundation

struct Validator {
    static let nicknameRegex = "[가-힣a-zA-Z0-9_-]{2,10}"

    static let tistoryRegex = #"^https://?[a-z0-9-]{4,32}.tistory.com[/]{0,1}$"#
    static let velogRegex = #"^https://velog.io/@?[A-Za-z0-9-_]{3,16}$"#

    static func validate(nickname: String) -> Bool {
        return nickname.isValidRegex(regex: nicknameRegex)
    }

    static func validate(blogLink: String) -> Bool {
        if blogLink.isValidRegex(regex: tistoryRegex) || blogLink.isValidRegex(regex: velogRegex) {
            return true
        }
        return false
    }

    static func validateIsEmpty(blogLink: String) -> Bool {
        if blogLink.isEmpty { return true }
        if blogLink.isValidRegex(regex: tistoryRegex) || blogLink.isValidRegex(regex: velogRegex) {
            return true
        }
        return false
    }
}
