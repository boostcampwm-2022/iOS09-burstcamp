//
//  UserManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/30.
//

import Combine
import Foundation

import BCFirebase

final class UserManager {

    static let shared = UserManager()

    private(set) var user = User(dictionary: [:])
    private let bCFirestoreUserListener = BCFirestoreUserListener()
    private let bcFirebaseAuthService = BCFirebaseAuthService()
    let userUpdatePublisher = PassthroughSubject<User, Error>()

    private var cancelBag = Set<AnyCancellable>()

    private init() {}

    private func userByKeyChain() {
        if let user = KeyChainManager.readUser() {
            self.user = user
        }
    }

    func appStart() {
        userByKeyChain()
    }

    func setUser(_ user: User) {
        self.user = user
    }

    func addUserListener() {
        if user.userUUID.isEmpty { fatalError("Listenr를 위한 UserUUID가 없음") }
        bCFirestoreUserListener.userPublisher(userUUID: user.userUUID)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error): self?.userUpdatePublisher.send(completion: .failure(error))
                case .finished: return
                }
            }
            receiveValue: { [weak self] userAPIModel in
                let user = User(userAPIModel: userAPIModel)
                self?.user = user
                self?.userUpdatePublisher.send(user)
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
