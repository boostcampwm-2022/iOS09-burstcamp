//
//  Validation.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import Foundation

struct Validation {
    static func validate(name: String) -> Bool {
        return name.isEmpty ? false : true
    }

    static func validate(camperID: String) -> Bool {
        return camperID.count == 3 ? true : false
    }

    static func validate(blogLink: String) -> Bool {
        let tistoryRegexp = #"^https://?[a-z0-9-]{4,32}.tistory.com$"#
        let velogRegexp = #"^https://velog.io/@?[A-Za-z0-9-_]{3,16}$"#
        if blogLink.range(of: tistoryRegexp, options: .regularExpression) != nil {
            return true
        } else if blogLink.range(of: velogRegexp, options: .regularExpression) != nil {
            return true
        }
        return false
    }
}
