//
//  User.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct User: Codable {
    let userUUID: String
    let nickname: String
    let profileImageURL: String
    let domain: Domain
    let camperID: String
    let ordinalNumber: Int
    let blogURL: String
    let blogTitle: String
    let scrapFeedUUIDs: [String]
    let signupDate: Date
    let isPushOn: Bool
}
