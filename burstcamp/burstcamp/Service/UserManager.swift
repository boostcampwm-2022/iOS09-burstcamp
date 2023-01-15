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
//    private let userPath = FirestoreCollection.user.reference
//    private var listenerRegistration: ListenerRegistration?
    let userUpdatePublisher = PassthroughSubject<User, Never>()

    private init() {}

    private func userByKeyChain() {
        if let user = KeyChainManager.readUser() {
            self.user = user
            print(user)
        }
    }

//    private func addUserListener() {
//        guard let userUUID = Auth.auth().currentUser?.uid else { return }
//        listenerRegistration = userPath.document(userUUID)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("user 업데이트 실패 \(error.localizedDescription)")
//                    return
//                }
//                guard let dictionary = snapshot?.data() else { return }
//                let user = User(dictionary: dictionary)
//                self.user = user
//                self.userUpdatePublisher.send(user)
//            }
//    }

    func appStart() {
        userByKeyChain()
    }

//    func addListener() {
//        addUserListener()
//    }

    func deleteUserInfo() {
        user = User(dictionary: [:])
    }

//    func removeUserListener() {
//        listenerRegistration?.remove()
//    }
}
