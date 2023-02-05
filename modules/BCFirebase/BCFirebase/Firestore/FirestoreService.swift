//
//  FirestoreService.swift
//  burstcamp
//
//  Created by youtak on 2022/12/10.
//

import Foundation

import FirebaseFirestore

public typealias FirestoreData = [String: Any]

public final class FirestoreService {

    private let database: Firestore

    init(database: Firestore) {
        self.database = database
    }

    convenience init() {
        let database = Firestore.firestore()
        self.init(database: database)
    }

    func createPaginateQuery(
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

    func getCollection(_ collectionPath: String) async throws -> [FirestoreData] {
        let querySnapshot = try await database.collection(collectionPath).getDocuments()
        return querySnapshot.documents.map { $0.data() }
    }

    func getCollection(
        _ collectionPath: String,
        _ makeQuery: (_ collection: CollectionReference) -> Query
    ) async throws -> [FirestoreData] {
        let querySnapshot = try await makeQuery(database.collection(collectionPath)).getDocuments()
        return querySnapshot.documents.map { $0.data() }
    }

    func getCollection(query: Query) async throws -> (
        collectionData: [FirestoreData],
        lastSnapshot: QueryDocumentSnapshot?
    ) {
        let querySnapshot = try await query.getDocuments()
        let lastSnapshot = querySnapshot.documents.last
        let collectionData = querySnapshot.documents.map { $0.data() }

        return(collectionData, lastSnapshot)
    }

    func countCollection(_ collectionPath: String) async throws -> Int {
        let countQuery = database.collection(collectionPath).count
        let collectionCount = try await countQuery.getAggregation(source: .server).count
        return Int(truncating: collectionCount)
    }

    func countCollection(
        _ collectionPath: String,
        _ makeQuery: (_ collection: CollectionReference) -> Query
    ) async throws -> Int {
        let countQuery = makeQuery(database.collection(collectionPath)).count
        let collectionCount = try await countQuery.getAggregation(source: .server).count
        return Int(truncating: collectionCount)
    }

    func getDocument(_ collectionPath: String, document: String) async throws -> FirestoreData {
        let documentSnapshot = try await database.collection(collectionPath).document(document).getDocument()
        guard let documentData = documentSnapshot.data() else {
            throw FirestoreServiceError.getDocument
        }
        return documentData
    }

    func getDocument(_ collectionPath: String, field: String, isEqualTo: Any) async throws -> [FirestoreData] {
        let collectionRef = database.collection(collectionPath)
        let query = collectionRef.whereField(field, isEqualTo: isEqualTo)
        let documentSnapshot = try await query.getDocuments()
        return documentSnapshot.documents.map { $0.data() }
    }

    func createDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    ) async throws {
        try await database.collection(collectionPath).document(document).setData(data)
    }

    func updateDocument(
        _ collectionPath: String,
        document: String,
        data: FirestoreData
    )  async throws {
        try await database.collection(collectionPath).document(document).updateData(data)
    }

    func deleteDocument(_ collectionPath: String, document: String) async throws {
        try await database.collection(collectionPath).document(document).delete()
    }

    func getDocumentReference(_ collectionPath: String, document: String) -> DocumentReference {
        return database.collection(collectionPath).document(document)
    }

    func getDatabaseBatch() -> WriteBatch {
        return database.batch()
    }

    func getDocumentPath(collection: String, document: String) -> DocumentReference {
        return database.collection(collection).document(document)
    }
}
