//
//  SignUpUser.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

struct SignUpUser {
    private var nickname: String?
    private var domain: Domain?
    private var camperID: String?
    private var blogURL: String = ""

    mutating func setNickname(_ nickname: String) {
        self.nickname = nickname
    }

    mutating func setDomain(_ domain: Domain) {
        self.domain = domain
    }

    mutating func setCamperID(_ camperID: String) {
        self.camperID = camperID
    }

    mutating func setBlogURL(_ blogURL: String) {
        self.blogURL = blogURL
    }
}
