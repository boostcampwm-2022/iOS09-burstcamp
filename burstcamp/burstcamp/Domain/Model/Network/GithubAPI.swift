//
//  GithubAPI.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

struct APIKey: Codable {
    let github: Github
}

struct Github: Codable {
    let clientID: String
    let clientSecret: String
}
