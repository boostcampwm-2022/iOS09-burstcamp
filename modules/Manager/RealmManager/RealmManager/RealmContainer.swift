//
//  RealmContainer.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import class Realm.RLMRealmConfiguration
import class RealmSwift.Object
import struct RealmSwift.Realm
import struct RealmSwift.Results
import protocol RealmSwift.RealmFetchable

public final class Container {
    
    private let realm: Realm

    public convenience init(
        debug: Bool = false,
        schemaVersion: UInt64 = 0
    ) throws {
        if debug { print("Realm Database 위치 :", RLMRealmConfiguration.default().fileURL) }
        let config = Realm.Configuration(schemaVersion: schemaVersion)
        try self.init(realm: Realm(configuration: config))
    }

    internal init(realm: Realm) {
        self.realm = realm
    }

    public func write(
        _ block: (_ transaction: WriteTransaction) throws -> Void
    ) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }

    public func values<T: Object>(
        _ type: T.Type
    ) -> Results<T> {
        return realm.objects(type)
    }

    public func values<T>(
        _ type: T.Type,
        query: T.Query? = nil,
        sort: T.Sort? = nil
    ) -> FetchedResults<T>
    where T: RealmCompatible & QuerySupportable & SortSupportable {
        var results = realm.objects(T.RealmModel.self)

        if let predicate = query?.predicate {
            results = results.filter(predicate)
        }

        if let sort = sort?.sortDescriptors {
            results = results.sorted(by: sort)
        }

        return FetchedResults(results: results)
    }

    internal func object<Element: RealmFetchable>(_ type: Element.Type) -> Results<Element> {
        return realm.objects(type)
    }
}
