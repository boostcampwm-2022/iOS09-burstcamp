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
        return false
    }

    func login(code: String) async throws {
        try await loginRepository.authorizeBoostcamp(code: code)
    }
}
