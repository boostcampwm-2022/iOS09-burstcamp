//
//  FireStoreValues.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct FireStoreValues {
    struct StringValue: Codable {
        let value: String

        private enum CodingKeys: String, CodingKey {
            case value = "stringValue"
        }
    }

    struct BooleanValue: Codable {
        let value: Bool

        private enum CodingKeys: String, CodingKey {
            case value = "booleanValue"
        }
    }

    struct TimeStampValue: Codable {
        let value: String

        private enum CodingKeys: String, CodingKey {
            case value = "timestampValue"
        }
    }

    struct ArrayValue<T: Codable>: Codable {
        let arrayValue: [String: [T]]

        private enum CodingKeys: String, CodingKey {
            case arrayValue
        }

        init(values: [T]) {
            arrayValue = ["values": values]
        }
    }
}
