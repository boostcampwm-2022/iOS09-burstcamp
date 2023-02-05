//
//  Encodable+dictionary.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(
                with: object, options: []
              ) as? [String: Any]
        else { return nil }
        return dictinoary
    }
}
