//
//  DefaultMyPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultMyPageUseCase: MyPageUseCase {

    private let loginRepository: LoginRepository
    private let userRepository: UserRepository

    init(loginRepository: LoginRepository, userRepository: UserRepository) {
        self.loginRepository = loginRepository
        self.userRepository = userRepository
    }

    func withdrawal(code: String) async throws {
        let isSuccess = try await loginRepository.withdrawal(code: code)
        if !isSuccess { throw MyPageUseCaseError.withdrawal }
    }

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
    }

    func updateUserDarkModeState(appearance: Appearance) {
    }
}
