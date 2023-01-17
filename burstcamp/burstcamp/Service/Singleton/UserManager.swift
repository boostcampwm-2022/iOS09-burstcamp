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
    private let bCFirestoreUserListener = BCFirestoreUserListener()
    private let bcFirebaseAuthService = BCFirebaseAuthService()
    let userUpdatePublisher = PassthroughSubject<User, Never>()

    private var cancelBag = Set<AnyCancellable>()

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

    func setUser(_ user: User) {
        self.user = user
    }

    func addUserListener() {
        if user.userUUID.isEmpty { fatalError("Listenr를 위한 UserUUID가 없음")}
        bCFirestoreUserListener.userPublisher(userUUID: user.userUUID)
            .sink { error in
                fatalError("유저 정보를 불러오는데 실패 \(error)")
            } receiveValue: { userAPIModel in
                let user = User(userAPIModel: userAPIModel)
                self.userUpdatePublisher.send(user)
            }
            .store(in: &cancelBag)
    }

    func removeUserListener() {
        bCFirestoreUserListener.removeUserListener()
    }

    func deleteUserInfo() {
        user = User(dictionary: [:])
    }

    func setUserUUID(_ userUUID: String) {
        user = User(dictionary: ["userUUID": userUUID])
    }
}
