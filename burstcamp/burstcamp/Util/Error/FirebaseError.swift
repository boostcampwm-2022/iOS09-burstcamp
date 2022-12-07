//
//  FirebaseError.swift
//  burstcamp
//
//  Created by youtak on 2022/11/29.
//

import Foundation

enum FirebaseError: LocalizedError {
    case fetchUserError
    case fetchFeedError
    case fetchScrapCountError
    case lastFetchError
    case paginateQueryError
    case userDeleteError
    case userSignOutError

    var errorDescription: String? {
        switch self {
        case .fetchUserError: return "유저를 불러오던 중 에러가 발생했습니다."
        case .fetchFeedError: return "피드를 불러오던 중 에러가 발생했습니다."
        case .fetchScrapCountError: return "스크랩 수를 불러오던 중 에러가 발생했습니다."
        case .lastFetchError: return "마지막 스크랩입니다."
        case .paginateQueryError: return "피드를 추가로 불러오던 중 에러가 발생했습니다."
        case .userDeleteError: return "유저를 삭제하던 중 에러가 발생했습니다."
        case .userSignOutError: return "로그아웃 하던 중 에러가 발생했습니다."
        }
    }
}
