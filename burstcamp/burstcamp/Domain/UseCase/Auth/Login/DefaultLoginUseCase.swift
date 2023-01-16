//
//  DefaultLoginUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultLoginUseCase: LoginUseCase {

    private let loginRepository: LoginRepository

    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    func isLoggedIn() throws -> Bool {
        return try loginRepository.isLoggedIn()
    }

    func autoLogin() throws -> Bool {
    }

    func login(code: String) throws {
        // Firebase 로그인

        // 로그인 안 됨 -> 부캠 인증
    }

    func signOut(code: String) throws {
    }

    func authorizeBoostcamp(code: String) throws -> Bool {

        return false
    }
}
