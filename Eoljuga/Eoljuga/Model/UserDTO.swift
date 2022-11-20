//
//  UserDTO.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct FireStoreResult: Decodable {
    let document: DocumentResult
}

struct DocumentResult: Decodable {
    let fields: UserDTO
}

struct UserDTO: Codable {
    private let userUUID: StringValue
    private let name: StringValue
    private let profileImageURL: StringValue
    private let domain: StringValue
    private let camperID: StringValue
    private let blogUUID: StringValue
    private let signupDate: StringValue
    private let scrapFeedUUIDs: ArrayValue<StringValue>
    private let isPushNotification: BooleanValue

    private enum RootKey: String, CodingKey {
        case fields
    }

    private enum FieldKeys: String, CodingKey {
        case userUUID, name, profileImageURL, domain, caperID
        case blogUUID, signupDate, scrapFeedUUIDs
        case isPushNotification, isDarkMode
    }

    init(user: User) {
        self.userUUID = StringValue(value: user.userUUID)
        self.name = StringValue(value: user.name)
        self.profileImageURL = StringValue(value: user.profileImageURL)
        self.domain = StringValue(value: user.domain.rawValue)
        self.camperID = StringValue(value: user.camperID)
        self.blogUUID = StringValue(value: user.blogUUID)
        self.signupDate = StringValue(value: user.signupDate)
        self.scrapFeedUUIDs = ArrayValue<StringValue>(values: user.scrapFeedUUIDs.map {
            StringValue(value: $0) })
        self.isPushNotification = BooleanValue(value: user.isPushNotification)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userUUID = try container.decode(StringValue.self, forKey: .userUUID)
        self.name = try container.decode(StringValue.self, forKey: .name)
        self.profileImageURL = try container.decode(StringValue.self, forKey: .profileImageURL)
        self.domain = try container.decode(StringValue.self, forKey: .domain)
        self.camperID = try container.decode(StringValue.self, forKey: .camperID)
        self.blogUUID = try container.decode(StringValue.self, forKey: .blogUUID)
        self.signupDate = try container.decode(StringValue.self, forKey: .signupDate)
        self.scrapFeedUUIDs = try container.decode(
            ArrayValue<StringValue>.self,
            forKey: .scrapFeedUUIDs
        )
        self.isPushNotification = try container.decode(
            BooleanValue.self,
            forKey: .isPushNotification
        )
    }

    func toUser() -> User {
        return User(
            userUUID: userUUID.value,
            name: name.value,
            profileImageURL: profileImageURL.value,
            domain: Domain(rawValue: domain.value) ?? .iOS,
            camperID: camperID.value,
            blogUUID: blogUUID.value,
            signupDate: signupDate.value,
            scrapFeedUUIDs: scrapFeedUUIDs
                .arrayValue["values"]?
                .compactMap { $0.value } ?? [],
            isPushNotification: isPushNotification.value)
    }
}
