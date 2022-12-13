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
    public func publisher<Element: RealmFetchable>(
        _ type: Element.Type
    ) -> AnyPublisher<Results<Element>, Error> {
        return object(type)
            .collectionPublisher
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }
}
