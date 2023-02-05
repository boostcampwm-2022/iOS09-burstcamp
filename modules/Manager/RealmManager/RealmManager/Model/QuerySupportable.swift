//
//  QuerySupportable.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

public protocol QuerySupportable: RealmCompatible {
    associatedtype Query: QueryType
}

/// Query를 사용할 수 있도록 도와주는 protocol
public protocol QueryType {
    var predicate: NSPredicate? { get }
}
