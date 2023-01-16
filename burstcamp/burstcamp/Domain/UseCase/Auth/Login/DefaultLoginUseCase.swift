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

    func isLoggedIn() -> Bool {
        return loginRepository.isLoggedIn()
    }

    func login(code: String) async throws -> String {
        return try await loginRepository.login(code: code)
    }
}
