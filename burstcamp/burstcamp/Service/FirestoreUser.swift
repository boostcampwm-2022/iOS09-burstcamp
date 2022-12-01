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
    private static let userPath = Firestore.firestore().collection(FireStoreCollection.user.path)
    private static let userUUIDField = "userUUID"
    private static let isPushOnField = "isPushOn"

    static func save(user: User) -> AnyPublisher<User, FirestoreError> {
        let path = userPath.document(user.userUUID)
        guard let dictionary = user.asDictionary else {
            return Fail(error: FirestoreError.failAsDictionary).eraseToAnyPublisher()
        }
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
}
