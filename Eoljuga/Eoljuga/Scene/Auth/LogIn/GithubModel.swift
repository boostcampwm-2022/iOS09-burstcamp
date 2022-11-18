//
//  GithubModel.swift
//  Eoljuga
//
//  Created by 김기훈 on 2022/11/18.
//

import Foundation

struct Info: Codable {
    let github: Github
}

struct Github: Codable {
    let clientID: String
    let clientSecret: String
}
