//
//  BCUserListener.swift
//  burstcamp
//
//  Created by youtak on 2023/01/17.
//

import Combine
import Foundation

import FirebaseFirestore

final class BCFirestoreUserListener {

    private let firestoreService: FirestoreService
    private var userListener: ListenerRegistration?
    private var userListenerPublisher = PassthroughSubject<UserAPIModel, Error>()

    init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func userPublisher(userUUID: String) -> AnyPublisher<UserAPIModel, Error> {
        addListener(userUUID: userUUID)
        return userListenerPublisher.eraseToAnyPublisher()
    }

    private func addListener(userUUID: String) {
        let userPath = FirestoreCollection.user.path
        let documentReference = firestoreService.getDocumentReference(userPath, document: userUUID)

        self.userListener = documentReference.addSnapshotListener{ [weak self] documentSnapshot, error in
            if let error = error {
                self?.userListenerPublisher.send(completion: .failure(error))
            }
            guard let documentSnapshot = documentSnapshot,
                  let data = documentSnapshot.data()
            else {
                self?.userListenerPublisher.send(completion: .failure(FirestoreServiceError.userListener))
                return
            }
            let userAPIModel = UserAPIModel(data: data)
            self?.userListenerPublisher.send(userAPIModel)
        }
    }

    func removeUserListener() {
        userListener?.remove()
    }
}
