//
//  FirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

typealias FirestoreData = [String: Any]

final class FirestoreService {

    private let database: Firestore

    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }

    public func createQuery() {}
    public func getCollection() {}
    public func getDocument() {}
    public func countCollection() {}
    public func appendDocument() {}
    public func deleteDocument() {}
    public func appendDocumentField() {}
    public func deleteDocumentField() {}
}
