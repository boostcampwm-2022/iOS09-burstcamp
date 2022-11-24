//
//  APIKey.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Foundation

struct APIKey: Codable {
    let github: Github
}

struct Github: Codable {
    let clientID: String
    let clientSecret: String
}

struct GithubToken: Codable {
    let accessToken: String
    let scope: String
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

struct GithubUser: Codable {
    let login: String
}

struct GithubMembership: Codable {
    let role: String
    let user: MembershipUser

    enum CodingKeys: String, CodingKey {
        case role
        case user
    }
}

struct MembershipUser: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let htmlURL: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case htmlURL = "html_url"
        case type
    }
}
