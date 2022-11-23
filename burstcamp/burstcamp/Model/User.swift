//
//  User.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct User: Codable {
    let userUUID: String
    let name: String
    let profileImageURL: String
    let domain: Domain
    let camperID: String
    let blogUUID: String
    let signupDate: String
    let scrapFeedUUIDs: [String]
    let isPushNotification: Bool
}
