//
//  DefaultUserRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultUserRepository: UserRepository {

    private let bcFirestoreService: BCFirestoreService

    init(bcFirestoreService: BCFirestoreService) {
        self.bcFirestoreService = bcFirestoreService
    }

    func saveUser(_ user: User) async throws {
        let userAPIModel = userToAPIModel(user)
        try await bcFirestoreService.saveUser(userUUID: user.userUUID, user: userAPIModel)
    }

    func updateUser(_ user: User) async throws {
        let userAPIModel = userToAPIModel(user)
        try await bcFirestoreService.saveUser(userUUID: user.userUUID, user: userAPIModel)
    }

    func removeUser(_ user: User) async throws {
        try await bcFirestoreService.deleteUser(userUUID: user.userUUID)
    }

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
            isPushOn: user.isPushOn
        )
    }
}
