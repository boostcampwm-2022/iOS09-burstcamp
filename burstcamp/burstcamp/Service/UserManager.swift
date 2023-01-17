//
//  UserManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/30.
//

import Combine
import Foundation

final class UserManager {

    static let shared = UserManager()

    private(set) var user = User(dictionary: [:])
    private let bcFirestoreService = BCFirestoreService()
    private let bcFirebaseAuthService = BCFirebaseAuthService()
    let userUpdatePublisher = PassthroughSubject<User, Never>()

    private init() {}

    private func userByKeyChain() {
        if let user = KeyChainManager.readUser() {
            self.user = user
            print("키체인 매니저", user)
        }
    }

    func appStart() {
        userByKeyChain()
    }

    func addUserListener() {
        Task { [weak self] in
            do {
                guard let self = self else { throw UserManagerError.weakSelfIsNil }
                let userUUID = try self.bcFirebaseAuthService.getCurrentUserUid()
                let userAPIModel = try await self.bcFirestoreService.addListenerToUser(userUUID: userUUID)
                let user = User(userAPIModel: userAPIModel)
                self.user = user
                debugPrint("유저 매니저", self.user)
                self.userUpdatePublisher.send(user)
            } catch {
                debugPrint(error)
            }
        }
    }

    func removeUserListener() {
        bcFirestoreService.removeUserListener()
    }

    func deleteUserInfo() {
        user = User(dictionary: [:])
    }

    func setUserUUID(_ userUUID: String) {
        user = User(dictionary: ["userUUID": userUUID])
    }
}
