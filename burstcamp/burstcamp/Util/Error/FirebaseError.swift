//
//  FirebaseError.swift
//  burstcamp
//
//  Created by youtak on 2022/11/29.
//

import Foundation

enum FirebaseError: LocalizedError {

    /// 유저
    case fetchUserError
    case userDeleteError
    case userSignOutError

    /// 피드
    case fetchFeedError
    case fetchRecommendFeedError
    case fetchScrapCountError
    case lastFetchError
    case paginateQueryError

    var errorDescription: String? {
        switch self {
        /// 유저
        case .fetchUserError: return "유저를 불러오던 중 에러가 발생했습니다."
        case .userDeleteError: return "유저를 삭제하던 중 에러가 발생했습니다."
        case .userSignOutError: return "로그아웃 하던 중 에러가 발생했습니다."

        /// 피드
        case .fetchFeedError: return "피드를 불러오던 중 에러가 발생했습니다."
        case .fetchRecommendFeedError: return "추천 피드를 불러오던 중 에러가 발생했습니다."
        case .fetchScrapCountError: return "스크랩 수를 불러오던 중 에러가 발생했습니다."
        case .lastFetchError: return "마지막 스크랩입니다."
        case .paginateQueryError: return "피드를 추가로 불러오던 중 에러가 발생했습니다."
        }
    }
}
