//
//  URLRegularExpression.swift
//  burstcamp
//
//  Created by neuli on 2022/11/30.
//

import Foundation

enum URLRegularExpression {
    static let tistory = #"^https://?[a-z0-9-]{4,32}.tistory.com$"#
    static let velog = #"^https://velog.io/@?[A-Za-z0-9-_]{3,16}$"#
}
