//
//  SortingPolicy.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/16.
//

import RealmSwift

public typealias SortingPolicy<T, U> = (keyPath: KeyPath<T, U>, ascending: Bool)

public extension RealmCollection {
    func sorted<T: _HasPersistedType>(using policy: SortingPolicy<Element, T>) -> Results<Element>
    where T.PersistedType: SortableType, Element: ObjectBase {
        sorted(by: policy.keyPath, ascending: policy.ascending)
    }
}
