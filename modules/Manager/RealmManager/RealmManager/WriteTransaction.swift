//
//  WriteTransaction.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import struct RealmSwift.Realm
import class RealmSwift.Object

public final class WriteTransaction {
    
    private let realm: Realm

    internal init(realm: Realm) {
        self.realm = realm
    }

    public func add<T: RealmCompatible>(
        _ value: T,
        update: Realm.UpdatePolicy = .modified
    ) {
        realm.add(value.realmModel(), update: update)
    }

    /// Object Model을 직접 받는 add
    public func add<T: Object>(
        _ value: T,
        update: Realm.UpdatePolicy = .modified
    ) {
        realm.add(value, update: update)
    }

    /// Object Model을 직접 받고 autoIncrement를 지원
    public func add<T>(
        _ value: T,
        autoIncrement: Bool,
        defaultIndex: Int = 0,
        update: Realm.UpdatePolicy = .modified
    ) where T: Object & AutoIncrementable {
        if autoIncrement {
            let maxIndex = realm.objects(T.self)
                .map(\.autoIndex)
                .max() ?? defaultIndex

            value.autoIndex = maxIndex + 1
        }
        realm.add(value, update: update)
    }

    /// auto Increment를 지원
    public func add<T: RealmCompatible>(
        _ value: T,
        autoIncrement: Bool,
        defaultIndex: Int = 0,
        update: Realm.UpdatePolicy = .modified
    ) where T.RealmModel: AutoIncrementable {
        add(value.realmModel(), autoIncrement: autoIncrement)
    }

    public func update<T: RealmCompatible>(
        _ type: T.Type,
        values: [T.PropertyValue]
    ) {
        var dictionary: [String: Any] = [:]
        values.forEach {
            let pair = $0.propertyValuePair
            dictionary[pair.name] = pair.value
        }

        realm.create(T.RealmModel.self, value: dictionary, update: .modified)
    }

    /// Object Model을 직접 받고 autoIncrement를 지원
    public func delete<T>(
        _ value: T
    ) where T: Object {
        realm.delete(value)
    }
}
