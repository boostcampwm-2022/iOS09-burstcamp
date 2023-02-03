//
//  UserDefaultsService.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import Foundation

protocol UserDefaultsService {
    func save<T>(value: T, forKey key: String)
    func value<T>(valueType: T.Type, forKey key: String) -> T?
    func stringValue(forKey key: String) -> String?
    func delete(forKey key: String)
}
