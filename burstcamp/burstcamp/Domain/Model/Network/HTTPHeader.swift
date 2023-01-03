//
//  HTTPHeader.swift
//  burstcamp
//
//  Created by neuli on 2022/11/25.
//

import Foundation

enum HTTPHeader {
    case contentTypeApplicationJSON
    case acceptApplicationJSON
    case acceptApplicationVNDGithubJSON
    case authorizationBearer(token: String)
    case contentTypeTextPlain

    var keyValue: (key: String, value: String) {
        switch self {
        case .contentTypeApplicationJSON:
            return (key: "Content-Type", value: "application/json")
        case .acceptApplicationJSON:
            return (key: "Accept", value: "application/json")
        case .acceptApplicationVNDGithubJSON:
            return (key: "Accept", value: "application/vnd.github+json")
        case .authorizationBearer(let token):
            return (key: "Authorization", value: "Bearer \(token)")
        case .contentTypeTextPlain:
            return (key: "Content-Type", value: "text/plain")
        }
    }
}
