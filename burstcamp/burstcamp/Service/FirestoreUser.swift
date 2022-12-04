//
//  FirestoreUser.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import Foundation

import FirebaseFirestore

struct FirestoreUser {
    private static let userPath = FirestoreCollection.user.reference
    private static let userUUIDField = "userUUID"
    private static let profileImageURLField = "profileImageURL"
    private static let nicknameField = "nickname"
    private static let blogURLField = "blogURL"
    private static let blogTitleField = "blogTitle"
    private static let isPushOnField = "isPushOn"

    static func save(user: User) -> AnyPublisher<User, FirestoreError> {
        let path = userPath.document(user.userUUID)
        guard var dictionary = user.asDictionary else {
            return Fail(error: FirestoreError.failAsDictionary).eraseToAnyPublisher()
        }
        dictionary["signupDate"] = Timestamp()
        return Future<User, FirestoreError> { promise in
            path.setData(dictionary) { error in
                if error != nil {
                    promise(.failure(FirestoreError.setDataError))
                    return
                }
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }

    static func fetch(userUUID: String) -> AnyPublisher<User, FirestoreError> {
        return Future<User, FirestoreError> { promise in
            userPath.document(userUUID)
                .getDocument { document, error in
                    if error != nil {
                        promise(.failure(FirestoreError.setDataError))
                        return
                    }
                    if let document = document,
                       document.exists,
                       let dictionary = document.data() {
                        let user = User(dictionary: dictionary)
                        promise(.success(user))
                    } else {
                        promise(.failure(FirestoreError.noDataError))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    static func update(userUUID: String, isPushOn: Bool) {
        userPath.document(userUUID)
            .updateData([isPushOnField: isPushOn])
    }

    static func update(
        userUUID: String,
        nickname: String,
        profileImageURL: String,
        blogURL: String,
        blogTitle: String
    ) {
        userPath.document(userUUID)
            .updateData([
                nicknameField: nickname,
                profileImageURLField: profileImageURL,
                blogURLField: blogURL,
                blogTitleField: blogTitle
            ])
    }

    static func delete(user: User) {
        userPath.document(user.userUUID)
            .delete()
    }
}
