//
//  BlogDTO.swift
//  burstcamp
//
//  Created by neuli on 2022/11/25.
//

import Foundation

struct BlogDocumentResult: Decodable {
    let fields: BlogDTO
}

struct BlogDTO: Codable {
    private let blogUUID: FireStoreValues.StringValue
    private let userUUID: FireStoreValues.StringValue
    private let url: FireStoreValues.StringValue
    private let rssURL: FireStoreValues.StringValue
    private let title: FireStoreValues.StringValue

    private enum FieldKeys: String, CodingKey {
        case blogUUID
        case userUUID
        case url
        case rssURL
        case title
    }

    init(blog: Blog) {
        self.blogUUID = FireStoreValues.StringValue(value: blog.blogUUID)
        self.userUUID = FireStoreValues.StringValue(value: blog.userUUID)
        self.url = FireStoreValues.StringValue(value: blog.url)
        self.rssURL = FireStoreValues.StringValue(value: blog.rssURL)
        self.title = FireStoreValues.StringValue(value: blog.title)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blogUUID = try container.decode(FireStoreValues.StringValue.self, forKey: .blogUUID)
        self.userUUID = try container.decode(FireStoreValues.StringValue.self, forKey: .userUUID)
        self.url = try container.decode(FireStoreValues.StringValue.self, forKey: .url)
        self.rssURL = try container.decode(FireStoreValues.StringValue.self, forKey: .rssURL)
        self.title = try container.decode(FireStoreValues.StringValue.self, forKey: .title)
    }

    func toBlog() -> Blog {
        return Blog(
            blogUUID: blogUUID.value,
            userUUID: userUUID.value,
            url: url.value,
            rssURL: rssURL.value,
            title: title.value
        )
    }
}
