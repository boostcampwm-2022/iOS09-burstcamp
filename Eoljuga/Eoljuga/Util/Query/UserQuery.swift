//
//  UserQuery.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

enum UserQuery: Query {
    static func saveQuery(user: User) -> Data? {
        let userDTO = UserDTO(user: user)
        let queryData = [FireStoreField.fields: userDTO]

        return createHttpBody(data: queryData)
    }

    static func selectUser(by userUUID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "User" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "userUUID" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(userUUID)" }
                    },
                },
                "limit": 1
            }
        }
        """.data(using: .utf8)
    }
}
