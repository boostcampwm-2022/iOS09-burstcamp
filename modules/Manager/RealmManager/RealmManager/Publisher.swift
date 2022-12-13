//
//  Publisher.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import struct Combine.AnyPublisher

import protocol RealmSwift.RealmFetchable
import struct RealmSwift.Results

extension Container {
    public func publisher<T: RealmFetchable>(_ type: T.Type)
    -> AnyPublisher<Results<T>, Error> {
        return object(type)
            .collectionPublisher
            .threadSafeReference()
            .eraseToAnyPublisher()
    }
}
