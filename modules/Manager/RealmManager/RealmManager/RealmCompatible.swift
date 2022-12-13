//
//  RealmCompatible.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import class RealmSwift.Object
import struct RealmSwift.SortDescriptor

/// 구조체를 RealmSwift에서 사용할 수 있도록 래핑해주는 `protocol`
public protocol RealmCompatible {
    associatedtype RealmModel: RealmSwift.Object
    associatedtype PropertyValue: PropertyValueType
    associatedtype Query: QueryType
    associatedtype Sort: SortingType

    init(realmModel: RealmModel)
    func realmModel() -> RealmModel
}

/// 데이터를 type-safe 하게 사용할 수 있도록 도와주는 `typealias`
public typealias PropertyValuePair = (name: String, value: Any)

/// 데이터를 type-safe 하게 사용할 수 있도록 도와주는 `protocol`
public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

/// Foundation의 SortDescriptor과 구별하기 위한 `typealias`
///
/// @discussion
/// 이를 통해, 상위 모듈에서 "렐름"을 Import하지 않아도 된다.
public typealias RealmSortDescriptor = RealmSwift.SortDescriptor

/// Query를 사용할 수 있도록 도와주는 protocol
public protocol QueryType {
    var predicate: NSPredicate? { get }
}
public protocol SortingType {
    var sortDescriptors: [RealmSortDescriptor] { get }
}
