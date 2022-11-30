//
//  Decodable+Dictionary.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/11/29.
//

import Foundation

extension Decodable {
    init<Key>(_ dict: [Key: Any]) throws
    where Key: Hashable
    {
        let data = dict.data
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
