//
//  FirebaseAuthError.swift
//  burstcamp
//
//  Created by 김기훈 on 2022/12/09.
//

import Foundation

enum FirebaseAuthError: LocalizedError {
    case currentUserNil
    case failSignIn
    case readToken
    case userReAuth
    case userDelete
    case authSignOut
    case fetchUUID
}

extension FirebaseAuthError {
    var errorDescription: String? {
        switch self {
        case .currentUserNil: return "현재 유저가 없습니다."
        case .failSignIn: return "Fail to firebase auth signIn"
        case .readToken: return "토큰을 불러올 수 없습니다"
        case .userReAuth: return "재인증을 하던 중 에러가 발생했습니다."
        case .userDelete: return "유저를 삭제하던 중 에러가 발생했습니다."
        case .authSignOut: return "Fail to auth sign out"
        case .fetchUUID: return "UUID에 접근 하던 중 에러가 발생했습니다"
        }
    }
}
