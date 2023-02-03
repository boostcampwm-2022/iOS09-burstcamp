//
//  BCUserListener.swift
//  burstcamp
//
//  Created by youtak on 2023/01/17.
//

import Combine
import Foundation

import FirebaseFirestore

public final class BCFirestoreUserListener {

    private let firestoreService: FirestoreService
    private var userListener: ListenerRegistration?
    private var userListenerPublisher = PassthroughSubject<UserAPIModel, Error>()

    public init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }
    
    public convenience init() {
        let firestoreService = FirestoreService()
        self.init(firestoreService: firestoreService)
    }

    public func userPublisher(userUUID: String) -> AnyPublisher<UserAPIModel, Error> {
        addListener(userUUID: userUUID)
        return userListenerPublisher.eraseToAnyPublisher()
    }

    private func addListener(userUUID: String) {
        let userPath = FirestoreCollection.user.path
        let documentReference = firestoreService.getDocumentReference(userPath, document: userUUID)

        self.userListener = documentReference.addSnapshotListener { [weak self] documentSnapshot, error in
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

    public func removeUserListener() {
        userListener?.remove()
    }
}
