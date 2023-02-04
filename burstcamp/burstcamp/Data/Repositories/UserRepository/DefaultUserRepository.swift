//
//  DefaultUserRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

import BCFirebase

final class DefaultUserRepository: UserRepository {

    private let bcFirestoreService: BCFirestoreService
    private let bcFirebaseFunctionService: BCFirebaseFunctionService

    init(bcFirestoreService: BCFirestoreService, bcFirebaseFunctionService: BCFirebaseFunctionService) {
        self.bcFirestoreService = bcFirestoreService
        self.bcFirebaseFunctionService = bcFirebaseFunctionService
    }
    // MARK: User

    func fetchUser(_ userUUID: String) async throws -> User {
        do {
            return try await User(userAPIModel: bcFirestoreService.fetchUser(userUUID: userUUID))
        } catch {
            if let error = error as? FirestoreServiceError, error == .getDocument {
                throw UserRepositoryError.userNotExist
            } else {
                throw error
            }
        }
    }

    func saveUser(_ user: User) async throws {
        let userAPIModel = userToAPIModel(user)
        try await bcFirestoreService.saveUser(userUUID: user.userUUID, user: userAPIModel)
    }

    func updateUser(_ user: User) async throws {
        let userAPIModel = userToAPIModel(user)
        try await bcFirestoreService.saveUser(userUUID: user.userUUID, user: userAPIModel)
        try await bcFirebaseFunctionService.updateUserDB(user: userAPIModel)
    }

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws {
        try await bcFirestoreService.updateUserPushState(userUUID: userUUID, isPushOn: isPushOn)
    }

    func removeUser(_ user: User) async throws {
        try await bcFirestoreService.deleteUser(userUUID: user.userUUID)
    }

    // MARK: Token

    func saveFCMToken(_ token: String, to userUUID: String) async throws {
        try await bcFirestoreService.saveFCMToken(token, to: userUUID)
    }

    private func userToAPIModel(_ user: User) -> UserAPIModel {
        return UserAPIModel(
            userUUID: user.userUUID,
            nickname: user.nickname,
            profileImageURL: user.profileImageURL,
            domain: user.domain.rawValue,
            camperID: user.camperID,
            ordinalNumber: user.ordinalNumber,
            blogURL: user.blogURL,
            blogTitle: user.blogTitle,
            scrapFeedUUIDs: user.scrapFeedUUIDs,
            signupDate: user.signupDate,
            updateDate: user.updateDate,
            isPushOn: user.isPushOn
        )
    }

    // MARK: - 가입시 블로그 업데이트

    func updateBlog(with signUpUserUUID: String, blogURL: String) async throws {
        try await bcFirebaseFunctionService.updateBlog(with: signUpUserUUID, blogURL: blogURL)
    }

    // MARK: - Guest

    func saveGuest(userUUID: String) async throws -> User {
        let nickname = try getNickname(userUUID: userUUID)
        let guestUser = User(userUUID: userUUID, nickname: nickname)
        let guestUserAPIModel = userToAPIModel(guestUser)
        try await bcFirestoreService.saveUser(userUUID: guestUser.userUUID, user: guestUserAPIModel)
        return guestUser
    }

    private func getNickname(userUUID: String) throws -> String {
        if userUUID.count < 6 { throw UserRepositoryError.createGuestID }
        return "Guest-" + String(userUUID.prefix(6))
    }

    // MARK: - 찾기
    func isNicknameExist(_ nickname: String) async throws -> Bool {
        return try await bcFirestoreService.isExistNickname(nickname)
    }
}
