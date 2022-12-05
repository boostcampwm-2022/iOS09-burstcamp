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

extension GithubError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestAccessTokenError:
            return "AccessToken을 받을 수 없습니다"
        case .requestUserInfoError:
            return "Github UserInfo를 받을 수 없습니다"
        case .checkOrganizationError:
            return "캠퍼가 아닙니다"
        case .APIKeyError:
            return "관리자에게 문의해주세요 (APIKey)"
        case .encodingError:
            return "관리자에게 문의해주세요 (Github Request body)"
        }
    }
}
