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

    func withdrawalWithGithub(code: String) async throws {
        let user = UserManager.shared.user
        let isSuccess = try await loginRepository.withdrawalWithGithub(code: code, userUUID: user.userUUID)
        try await deleteProfileImage(userUUID: user.userUUID, profileImageURL: user.profileImageURL)
        deleteLocalUser()
        if !isSuccess { throw MyPageUseCaseError.withdrawal }
    }

    func withdrawalWithApple(idTokenString: String, nonce: String) async throws {
        let userUUID = UserManager.shared.user.userUUID
        let isSuccess = try await loginRepository.withdrawalWithApple(
            idTokenString: idTokenString,
            nonce: nonce,
            userUUID: userUUID
        )
        deleteLocalUser()
        if !isSuccess { throw MyPageUseCaseError.withdrawal }
    }

    private func deleteProfileImage(userUUID: String, profileImageURL: String) async throws {
        if !profileImageURL.hasPrefix("https://github.com/") {
            try await imageRepository.deleteProfileImage(userUUID: userUUID)
        }
    }

    // MARK: - 마이페이지 수정

    func canUpdateMyInfo() -> Bool {
        let updateDate = UserManager.shared.user.updateDate
        return updateDate.isPassed30Days()
    }

    func getNextUpdateDate() -> Date {
        let updateDate = UserManager.shared.user.updateDate
        return updateDate.after30Days()
    }

    // MARK: - 설정

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
        try await userRepository.updateUserPushState(userUUID: userUUID, isPushOn: isPushOn)
    }

    func updateUserDarkModeState(appearance: Appearance) {
        DarkModeManager.setAppearance(appearance)
    }

    func updateLocalUser(_ user: User) {
        KeyChainManager.save(user: user)
    }

    private func deleteLocalUser() {
        KeyChainManager.deleteUser()
        UserManager.shared.removeUserListener()
        UserManager.shared.deleteUserInfo()
    }
}
