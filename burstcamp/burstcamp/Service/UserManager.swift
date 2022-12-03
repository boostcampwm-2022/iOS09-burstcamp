//
//  UserManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/30.
//

import Combine
import Foundation

import FirebaseAuth
import FirebaseFirestore

final class UserManager {

    static let shared = UserManager()

    private(set) var user = User(dictionary: [:])
    private let userPath = Firestore.firestore().collection(FireStoreCollection.user.path)
    let userUpdatePublisher = PassthroughSubject<User, Never>()

    private init() {}

    func start() {
        userByKeyChain()
        addUserListener()
    }

    private func userByKeyChain() {
        if let user = KeyChainManager.readUser() {
            self.user = user
        }
    }

    private func addUserListener() {
        guard let userUUID = Auth.auth().currentUser?.uid else { return }
        userPath.document(userUUID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("user 업데이트 실패 \(error.localizedDescription)")
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                self.user = user
                self.userUpdatePublisher.send(user)
            }
    }
}
