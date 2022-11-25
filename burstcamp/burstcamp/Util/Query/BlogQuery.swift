//
//  BlogQuery.swift
//  burstcamp
//
//  Created by neuli on 2022/11/25.
//

import Foundation

enum BlogQuery: Query {
    
    static func insert(blog: Blog) -> Data? {
        let blogDTO = BlogDTO(blog: blog)
        let queryData = [FireStoreField.fields: blogDTO]
        
        return createHttpBody(data: queryData)
    }
    
    // blogUUID로 Blog select
    static func select(by blogUUID: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "\(FireStoreCollection.blog.rawValue)" },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "blogUUID" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(blogUUID)" }
                    },
                },
                "limit": 1
            }
        }
        """.data(using: .utf8)
    }
}
