//
//  FirebaseAuthError.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/09.
//

import Foundation

enum FirebaseAuthError: LocalizedError {
    case failSignInError
    case readTokenError
    case userReAuthError
    case userDeleteError
    case authSignOutError
    case fetchUUIDError
}

extension FirebaseAuthError {
    var errorDescription: String? {
        switch self {
        case .failSignInError: return "Fail to firebase auth signIn"
        case .readTokenError: return "토큰을 불러올 수 없습니다"
        case .userReAuthError: return "재인증을 하던 중 에러가 발생했습니다."
        case .userDeleteError: return "유저를 삭제하던 중 에러가 발생했습니다."
        case .authSignOutError: return "Fail to auth sign out"
        case .fetchUUIDError: return "UUID에 접근 하던 중 에러가 발생했습니다"
        }
    }
}
