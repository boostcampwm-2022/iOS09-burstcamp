//
//  FirestoreError.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//
import Foundation

enum FirestoreError: LocalizedError {

    /// 유저
    case fetchUserError
    case userDeleteError
    case userSignOutError
    case setDataError
    case noDataError
    case updateError

    /// 피드
    case fetchFeedError
    case fetchRecommendFeedError
    case fetchScrapCountError
    case lastFetchError
    case paginateQueryError
}

extension FirestoreError: CategorizedError {
    var category: ErrorCategory {
        return .retryable
    }
}

extension FirestoreError {
    var errorDescription: String? {
        switch self {
        /// 유저
        case .fetchUserError: return "유저를 불러오던 중 에러가 발생했습니다."
        case .userDeleteError: return "유저를 삭제하던 중 에러가 발생했습니다."
        case .userSignOutError: return "로그아웃 하던 중 에러가 발생했습니다."
        case .setDataError: return "유저를 설정하는 중 에러가 발생했습니다."
        case .noDataError: return "응답 데이터가 없습니다."
        case .updateError: return "유저를 업데이트하던 중 에러가 발생합니다."

        /// 피드
        case .fetchFeedError: return "피드를 불러오던 중 에러가 발생했습니다."
        case .fetchRecommendFeedError: return "추천 피드를 불러오던 중 에러가 발생했습니다."
        case .fetchScrapCountError: return "스크랩 수를 불러오던 중 에러가 발생했습니다."
        case .lastFetchError: return "버스트 캠프의 모든 스크랩을 불러왔어요"
        case .paginateQueryError: return "피드를 추가로 불러오던 중 에러가 발생했습니다."
        }
    }
}
