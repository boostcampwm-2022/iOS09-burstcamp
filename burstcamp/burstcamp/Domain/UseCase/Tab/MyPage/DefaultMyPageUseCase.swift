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
    private let imageRepository: ImageRepository

    init(loginRepository: LoginRepository, userRepository: UserRepository, imageRepository: ImageRepository) {
        self.loginRepository = loginRepository
        self.userRepository = userRepository
        self.imageRepository = imageRepository
    }

    func withdrawalWithGithub(code: String, userUUID: String) async throws {
        let isSuccess = try await loginRepository.withdrawalWithGithub(code: code)
        try await imageRepository.deleteProfileImage(userUUID: userUUID)
        KeyChainManager.deleteUser()
        if !isSuccess { throw MyPageUseCaseError.withdrawal }
    }

    func withdrawalWithApple() async throws {
    }

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
        try await userRepository.updateUserPushState(userUUID: userUUID, isPushOn: isPushOn)
    }

    func updateUserDarkModeState(appearance: Appearance) {
        DarkModeManager.setAppearance(appearance)
    }

    func updateLocalUser(_ user: User) {
        KeyChainManager.save(user: user)
    }
}
