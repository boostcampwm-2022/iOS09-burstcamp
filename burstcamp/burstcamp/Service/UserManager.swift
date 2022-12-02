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

    var userUpdatePublisher = PassthroughSubject<User, Never>()
    var user = User(dictionary: [:])

    // TODO: 삭제 예정
    var userUUID: String = ""
    var nickname: String = ""
    var profileImageURL: String = ""
    var domain: Domain = .iOS
    var camperID: String = ""
    var ordinalNumber: Int = 7
    var blogURL: String = ""
    var blogTitle: String = ""
    var scrapFeedUUIDs: [String] = []
    var signupDate: Date = Date()
    var isPushOn: Bool = false

    private let userPath = Firestore.firestore().collection(FireStoreCollection.user.path)

    private init() {
        addUserListener()
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
