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
        let querySnapshot = try await database.collection(collectionPath).getDocuments()
        return querySnapshot.documents.map { $0.data() }
    }

    public func getCollection(
        _ collectionPath: String,
        _ makeQuery: (_ collection: CollectionReference) -> Query
    ) async throws -> [FirestoreData] {
        let querySnapshot = try await makeQuery(database.collection(collectionPath)).getDocuments()
        return querySnapshot.documents.map { $0.data() }
    }

    public func getCollection(query: Query) async throws -> (
        collectionData: [FirestoreData],
        lastSnapshot: QueryDocumentSnapshot?
    ) {
        let querySnapshot = try await query.getDocuments()
        let lastSnapshot = querySnapshot.documents.last
        let collectionData = querySnapshot.documents.map { $0.data() }

        return(collectionData, lastSnapshot)
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
        let documentSnapshot = try await database.collection(collectionPath).document(document).getDocument()
        guard let documentData = documentSnapshot.data() else {
            throw FirestoreServiceError.getDocument
        }
        return documentData
    }

    public func createDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    ) async throws {
        try await database.collection(collectionPath).document(document).setData(data)
    }

    public func updateDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    )  async throws {
        try await database.collection(collectionPath).document(document).updateData(data)
    }

    public func deleteDocument(_ collectionPath: String, document: String) async throws {
        try await database.collection(collectionPath).document(document).delete()
    }

    public func getDocumentReference(_ collectionPath: String, document: String) -> DocumentReference {
        return database.collection(collectionPath).document(document)
    }

    public func getDatabaseBatch() -> WriteBatch {
        return database.batch()
    }

    public func getDocumentPath(collection: String, document: String) -> DocumentReference {
        return database.collection(collection).document(document)
    }
}
