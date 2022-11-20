//
//  Query.swift
//  FireStoreTest
//
//  Created by neuli on 2022/11/18.
//

import Foundation

protocol Query { }

extension Query {
    static func createHttpBody<T: Codable>(data: T) -> Data? {
        if let data = data as? Data {
            return data
        }
        return try? JSONEncoder().encode(data)
    }
}
