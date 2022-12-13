//
//  RealmCompatible.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmSwift

/// 구조체를 RealmSwift에서 사용할 수 있도록 래핑해주는 protocol
protocol RealmCompatible {
    associatedtype RealmModel: RealmSwift.Object
    associatedtype PropertyValue: PropertyValueType
    associatedtype Query: QueryType

    init(realmModel: RealmModel)
    func realmModel() -> RealmModel
}

/// 데이터를 type-safe 하게 사용할 수 있도록 도와주는 typealias
typealias PropertyValuePair = (name: String, value: Any)

/// 데이터를 type-safe 하게 사용할 수 있도록 도와주는 protocol
protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

/// Query를 사용할 수 있도록 도와주는 protocol
protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptors: [RealmSwift.SortDescriptor] { get }
}
