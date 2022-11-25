//
//  HTTPHeader.swift
//  burstcamp
//
//  Created by neuli on 2022/11/25.
//

import Foundation

enum HTTPHeader {
    case contentType_applicationJSON
    case accept_applicationJSON
    case accept_application_vndGithubJSON
    case authorization_Bearer(token: String)
    case contentType_textPlain
    
    var keyValue: (key: String, value: String) {
        switch self {
        case .contentType_applicationJSON:
            return (key: "Content-Type", value: "application/json")
        case .accept_applicationJSON:
            return (key: "Accept", value: "application/json")
        case .accept_application_vndGithubJSON:
            return (key: "Accept", value: "application/vnd.github+json")
        case .authorization_Bearer(let token):
            return (key: "Authorization", value: "Bearer \(token)")
        case .contentType_textPlain:
            return (key: "Content-Type", value: "text/plain")
        }
    }
}
