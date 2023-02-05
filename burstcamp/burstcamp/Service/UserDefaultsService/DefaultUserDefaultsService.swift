//
//  DefaultUserDefaultsService.swift
//  burstcamp
//
//  Created by neuli on 2023/01/31.
//

import Foundation

final class DefaultUserDefaultsService: UserDefaultsService {

    // MARK: - Properties

    private let standard = UserDefaults.standard

    // MARK: - Methods

    func save<T>(value: T, forKey key: String) {
        standard.set(value, forKey: key)
    }

    func value<T>(valueType: T.Type, forKey key: String) -> T? {
        guard let value = standard.object(forKey: key) as? T else { return nil }
        return value
    }

    func stringValue(forKey key: String) -> String? {
        return standard.string(forKey: key)
    }

    func delete(forKey key: String) {
        standard.removeObject(forKey: key)
    }
}
