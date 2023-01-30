//
//  DefaultLoginUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultLoginUseCase: LoginUseCase {

    private let loginRepository: LoginRepository
    private let userRepository: UserRepository

    init(loginRepository: LoginRepository, userRepository: UserRepository) {
        self.loginRepository = loginRepository
        self.userRepository = userRepository
    }

    func checkIsExist(userUUID: String) async throws -> Bool {
        do {
            let user = try await userRepository.fetchUser(userUUID)
            UserManager.shared.setUser(user)
            KeyChainManager.save(user: user)
            return true
        } catch {
            if let error = error as? UserRepositoryError, error == .userNotExist {
                return false
            } else {
                throw LoginUseCaseError.fetchUser
            }
        }
    }

    func isLoggedIn() -> Bool {
        return loginRepository.isLoggedIn() && KeyChainManager.readUser() != nil
    }

    func loginWithGithub(code: String) async throws -> (userNickname: String, userUUID: String) {
        return try await loginRepository.loginWithGithub(code: code)
    }

    func loginWithApple(idTokenString: String, nonce: String) async throws -> String {
        return try await loginRepository.loginWithApple(idTokenString: idTokenString, nonce: nonce)
    }

    func createGuest(userUUID: String) async throws {
        try await userRepository.saveGuest(userUUID: userUUID)
    }
}
