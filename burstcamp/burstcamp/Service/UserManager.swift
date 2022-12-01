//
//  UserManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/30.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

final class UserManager {

    static let shared = UserManager()

    // TODO: 임시 초기 데이터

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
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("user 업데이트 실패 \(error.localizedDescription)")
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                print(dictionary)
//                self?.user = User(dictionary: dictionary)
            }
    }
}
