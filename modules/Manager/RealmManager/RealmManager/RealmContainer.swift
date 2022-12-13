//
//  RealmContainer.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import Realm
import RealmSwift

public final class Container {
    
    private let realm: Realm

    public convenience init(_ debug: Bool = false) throws {
        if debug { print("Realm Database 위치 :", RLMRealmConfiguration.default().fileURL) }
        try self.init(realm: Realm())
    }

    init(realm: Realm) {
        self.realm = realm
    }

    public func write(
        _ block: (WriteTransaction) throws -> Void
    ) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }

    public func values<T: RealmCompatible>(
        _ type: T.Type,
        matching query: T.Query
    ) -> FetchedResults<T> {
        var results = realm.objects(T.RealmModel.self)

        if let predicate = query.predicate {
            results = results.filter(predicate)
        }

        results = results.sorted(by: query.sortDescriptors)

        return FetchedResults(results: results)
    }
}
