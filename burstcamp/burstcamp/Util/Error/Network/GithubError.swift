//
//  GithubError.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/05.
//

import Foundation

enum GithubError: LocalizedError {
    case requestAccessTokenError
    case requestUserInfoError
    case checkOrganizationError
    case APIKeyError
    case encodingError
}

extension GithubError {
    var errorDescription: String? {
        switch self {
        case .requestAccessTokenError:
            return "Github에서 AccessToken을 불러올 수 없습니다"
        case .requestUserInfoError:
            return "Github 유저 정보를 불러올 수 없습니다"
        case .checkOrganizationError:
            return "부스트캠퍼가 아닙니다"
        case .APIKeyError:
            return "관리자에게 문의해주세요 (APIKey)"
        case .encodingError:
            return "관리자에게 문의해주세요 (Github Request body)"
        }
    }
}
