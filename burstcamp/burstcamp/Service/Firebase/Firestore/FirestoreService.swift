//
//  FirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

enum FirestoreServiceError: Error {
    case getCollection
    case getDocument
    case lastCollectionError
}

typealias FirestoreData = [String: Any]

final class FirestoreService {

    private let database: Firestore

    init(database: Firestore) {
        self.database = database
    }

    convenience init() {
        let database = Firestore.firestore()
        self.init(database: database)
    }

    public func createPaginateQuery(
        collectionPath: String,
        field: String,
        count: Int,
        lastSnapShot: QueryDocumentSnapshot?
    ) -> Query {
        if let lastSnapShot = lastSnapShot {
            return database
                .collection(collectionPath)
                .order(by: field, descending: true)
                .limit(to: count)
                .start(afterDocument: lastSnapShot)
        } else {
            return database
                .collection(collectionPath)
                .order(by: field, descending: true)
                .limit(to: count)
        }
    }

    public func getCollection(collection: String) async throws -> [FirestoreData] {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collection)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapShot = querySnapshot else {
                        continuation.resume(throwing: FirestoreServiceError.getCollection)
                        return
                    }
                    let collectionData = querySnapShot.documents.map { $0.data() }
                    continuation.resume(returning: collectionData)
                }
        }
    }

    public func getCollection(
        query: Query
    ) async throws
    -> (
        collectionData: [FirestoreData],
        lastSnapshot: QueryDocumentSnapshot?
    ) {
        try await withCheckedThrowingContinuation { continuation in
            query
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let querySnapshot = querySnapshot else {
                        continuation.resume(throwing: FirestoreServiceError.getCollection)
                        return
                    }
                    let lastSnapshot = querySnapshot.documents.last
                    if lastSnapshot == nil {
                        continuation.resume(throwing: FirestoreServiceError.lastCollectionError)
                        return
                    }

                    let collectionData = querySnapshot.documents.map { $0.data() }
                    let result = (collectionData, lastSnapshot)
                    continuation.resume(returning: result)
                }
        }
    }

    public func getDocument(
        collectionPath: String,
        document: String
    ) async throws -> FirestoreData {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let documentSnapshot = documentSnapshot,
                          let documentData = documentSnapshot.data()
                    else {
                        continuation.resume(throwing: FirestoreServiceError.getDocument)
                        return
                    }
                    continuation.resume(returning: documentData)
                }
        }
    }

    public func countCollection(collectionPath: String) async throws -> Int {
        let countQuery = database.collection(collectionPath).count
        let collectionCount = try await countQuery.getAggregation(source: .server).count
        return Int(truncating: collectionCount)
    }

    public func appendDocument(
        collectionPath: String,
        document: String,
        value: FirestoreData
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .setData(value) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        }
        as Void
    }

    public func deleteDocument(
        collectionPath: String,
        document: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .delete { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    public func appendDocumentArrayField(
        collectionPath: String,
        document: String,
        arrayName: String,
        value: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .updateData([
                    arrayName: FieldValue.arrayUnion([value])
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }

    public func deleteDocumentArrayField(
        collectionPath: String,
        document: String,
        arrayName: String,
        value: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .updateData([
                    arrayName: FieldValue.arrayRemove([value])
                ]) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        } as Void
    }
}
