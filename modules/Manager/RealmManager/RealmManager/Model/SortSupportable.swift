//
//  SortSupportable.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import struct RealmSwift.SortDescriptor

public protocol SortSupportable: RealmCompatible {
    associatedtype Sort: SortingType
}

/// Foundation의 SortDescriptor과 구별하기 위한 `typealias`
///
/// @discussion
/// 이를 통해, 상위 모듈에서 "렐름"을 Import하지 않아도 된다.
public typealias RealmSortDescriptor = RealmSwift.SortDescriptor

public protocol SortingType {
    var sortDescriptors: [RealmSortDescriptor] { get }
}
