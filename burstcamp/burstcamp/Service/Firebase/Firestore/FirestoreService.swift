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
    private var listener: ListenerRegistration?

    init(database: Firestore) {
        self.database = database
    }

    convenience init() {
        let database = Firestore.firestore()
        self.init(database: database)
    }

    public func createPaginateQuery(
        _ collectionPath: String,
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

    public func getCollection(_ collectionPath: String) async throws -> [FirestoreData] {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
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
        _ collectionPath: String,
        _ makeQuery: (_ collection: CollectionReference) -> Query
    ) async throws -> [FirestoreData] {
        try await withCheckedThrowingContinuation { continuation in
            makeQuery(database.collection(collectionPath))
                .getDocuments(completion: { querySnapshot, error in
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
                })
        }
    }

    public func getCollection(query: Query) async throws -> (
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
                        continuation.resume(throwing: FirestoreServiceError.lastCollection)
                        return
                    }

                    let collectionData = querySnapshot.documents.map { $0.data() }
                    let result = (collectionData, lastSnapshot)
                    continuation.resume(returning: result)
                }
        }
    }

    public func countCollection(_ collectionPath: String) async throws -> Int {
        let countQuery = database.collection(collectionPath).count
        let collectionCount = try await countQuery.getAggregation(source: .server).count
        return Int(truncating: collectionCount)
    }

    public func countCollection(
        _ collectionPath: String,
        _ makeQuery: (_ collection: CollectionReference) -> Query
    ) async throws -> Int {
        let countQuery = makeQuery(database.collection(collectionPath)).count
        let collectionCount = try await countQuery.getAggregation(source: .server).count
        return Int(truncating: collectionCount)
    }

    public func getDocument(_ collectionPath: String, document: String) async throws -> FirestoreData {
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

    public func createDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .setData(data) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        }
        as Void
    }

    public func updateDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    )  async throws {
        try await withCheckedThrowingContinuation { continuation in
            database
                .collection(collectionPath)
                .document(document)
                .updateData(data) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                }
        }
        as Void
    }

    public func deleteDocument(_ collectionPath: String, document: String) async throws {
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

    public func addListenerToDocument(_ collectionPath: String, document: String) async throws -> FirestoreData {
        try await withCheckedThrowingContinuation { continuation in
            listener = database
                .collection(collectionPath)
                .document(document)
                .addSnapshotListener { documentSnapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    guard let documentSnapshot = documentSnapshot,
                          let data = documentSnapshot.data()
                    else {
                        continuation.resume(throwing: FirestoreServiceError.addListenerFail)
                        return
                    }
                    continuation.resume(returning: data)
                }
        }
    }

    public func removeListener() {
        listener?.remove()
        debugPrint("리스너 삭제")
    }

    public func getDatabaseBatch() -> WriteBatch {
        return database.batch()
    }

    public func getDocumentPath(collection: String, document: String) -> DocumentReference {
        return database.collection(collection).document(document)
    }
}
