//
//  AutoIncrementable.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import class RealmSwift.Object

/// 자동증가를 지원하기 위한 프로토콜
public protocol AutoIncrementable: RealmSwift.Object {
    var autoIndex: Int { get set }
}
