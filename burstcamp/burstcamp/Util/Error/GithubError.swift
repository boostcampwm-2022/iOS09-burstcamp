//
//  GithubError.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/05.
//

import Foundation

enum GithubError: Error {
    case requestAccessTokenError
    case requestUserInfoError
    case checkOrganizationError
    case APIKeyError
    case encodingError
}
