//
//  FetchedResults.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import Foundation

import RealmSwift

public final class FetchedResults<T: RealmCompatible> {

    internal let results: Results<T.RealmModel>

    public var count: Int {
        return results.count
    }

    internal init(results: Results<T.RealmModel>) {
        self.results = results
    }

    public func value(at index: Int) -> T? {
        guard index < count else { return nil }
        return T(realmModel: results[index])
    }
}
