//
//  RealmConvertible.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmSwift

public protocol RealmConvertible {
    associatedtype RealmModel: RealmSwift.Object
    init(realmModel: RealmModel)
    func realmModel() -> RealmModel
}
