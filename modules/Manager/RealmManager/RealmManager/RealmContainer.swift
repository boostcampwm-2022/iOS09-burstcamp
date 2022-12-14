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

///
///@discussion
/// * Realm 은 항상 serial Queue에서 동작해야 합니다.
/// * Realm 의 transaction은 항상 같은 thread에서 동작해야합니다.
public final class Container {
    
    private let realm: Realm
    public let serialQueue: DispatchQueue

    public init(
        debug: Bool = false,
        initialize: Bool = false,
        schemaVersion: UInt64 = 0,
        queue: DispatchQueue
    ) throws {
        if debug { print("Realm Database 위치 :", RLMRealmConfiguration.default().fileURL) }
        self.serialQueue = queue
        if initialize {
            let config = Realm.Configuration(schemaVersion: UInt64.max - 1)
            self.realm = try Realm(configuration: config, queue: queue)
            try realm.write {
                realm.deleteAll()
            }
        } else {
            let config = Realm.Configuration(schemaVersion: schemaVersion)
            self.realm = try Realm(configuration: config, queue: queue)
        }
    }

    public func write(
        _ block: @escaping (_ transaction: WriteTransaction) throws -> Void
    ) {
        serialQueue.async {
            let transaction = WriteTransaction(realm: self.realm)
            try! self.realm.write {
                try! block(transaction)
            }
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
