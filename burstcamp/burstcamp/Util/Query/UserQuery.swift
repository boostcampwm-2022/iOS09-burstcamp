//
//  UserQuery.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

enum UserQuery: Query {

    // 회원가입
    static func insert(user: User) -> Data? {
        let userDTO = UserDTO(user: user)
        let queryData = [FireStoreField.fields: userDTO]

        return createHttpBody(data: queryData)
    }

    // uuid로 user select
    static func select(by userUUID: String) -> Data? {
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

    // 마이페이지 수정
    static func update(user: User) -> Data? {
        return """
        {
            "fields": {
                "nickname": { "stringValue": "\(user.nickName)" },
                "blogUUID: { "stringValue": "\(user.blogUUID)" },
                "profileImageURL: { "stringValue: "\(user.profileImageURL)" }
            }
        }
        """.data(using: .utf8)
    }

    // 스크랩 피드 업데이트
    static func update(scrapFeedUUIDs: [String]) -> Data? {
        return """
        {
            "fields": {
                "scrapFeedUUIDs": { "arrayValue": "\(scrapFeedUUIDs)" },
            }
        }
        """.data(using: .utf8)
    }

    // 푸시알림 업데이트
    static func update(isPushOn: Bool) -> Data? {
        return """
        {
            "fields": {
                "isPushOn": { "stringValue": "\(isPushOn)" }
            }
        }
        """.data(using: .utf8)
    }
}
