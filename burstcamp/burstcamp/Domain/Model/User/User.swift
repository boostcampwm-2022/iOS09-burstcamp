//
//  User.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

struct User: Codable, Equatable {
    let userUUID: String
    private(set) var nickname: String
    private(set) var profileImageURL: String
    let domain: Domain
    let camperID: String
    let ordinalNumber: Int
    private(set) var blogURL: String
    let blogTitle: String
    private(set) var scrapFeedUUIDs: [String]
    let signupDate: Date
    private(set) var updateDate: Date
    let isPushOn: Bool

    mutating func setNickname(_ nickname: String) {
        self.nickname = nickname
    }

    mutating func setProfileImageURL(_ profileImageURL: String) {
        self.profileImageURL = profileImageURL
    }

    mutating func setBlogURL(_ blogURL: String) {
        self.blogURL = blogURL
    }

    mutating func setUpdateDate() {
        self.updateDate = Date()
    }
}

extension User {
    init(dictionary: [String: Any]) {
        self.userUUID = dictionary["userUUID"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        let domainString = dictionary["domain"] as? String ?? ""
        self.domain = Domain(rawValue: domainString) ?? .guest
        self.camperID = dictionary["camperID"] as? String ?? ""
        self.ordinalNumber = dictionary["ordinalNumber"] as? Int ?? 7
        self.blogURL = dictionary["blogURL"] as? String ?? ""
        self.blogTitle = dictionary["blogTitle"] as? String ?? ""
        self.scrapFeedUUIDs = dictionary["scrapFeedUUIDs"] as? [String] ?? []
        self.signupDate = dictionary["signupDate"] as? Date ?? Date()
        self.updateDate = dictionary["updateDate"] as? Date ?? Date(timeIntervalSince1970: 0)
        self.isPushOn = dictionary["isPushOn"] as? Bool ?? false
    }

    // MARK: - 회원가입을 위한 유저 이니셜라이져

    init?(userUUID: String, signUpUser: SignUpUser, blogTitle: String) {
        self.userUUID = userUUID

        if let nickname = signUpUser.getNickname(),
           let domain = signUpUser.getDomain(),
           let camperID = signUpUser.getCamperID() {
            self.nickname = nickname
            self.profileImageURL = "https://github.com/\(nickname).png"
            self.domain = domain
            self.camperID = camperID
        } else {
            return nil
        }

        self.ordinalNumber = 7
        self.blogURL = signUpUser.getBlogURL()
        self.blogTitle = blogTitle
        self.scrapFeedUUIDs = []
        self.signupDate = Date()
        self.updateDate = Date(timeIntervalSince1970: 0)
        self.isPushOn = false
    }

    // MARK: - UserAPIModel -> User

    init(userAPIModel: UserAPIModel) {
        self.userUUID = userAPIModel.userUUID
        self.nickname = userAPIModel.nickname
        self.profileImageURL = userAPIModel.profileImageURL
        self.domain = Domain(rawValue: userAPIModel.domain) ?? .iOS
        self.camperID = userAPIModel.camperID
        self.ordinalNumber = userAPIModel.ordinalNumber
        self.blogURL = userAPIModel.blogURL
        self.blogTitle = userAPIModel.blogTitle
        self.scrapFeedUUIDs = userAPIModel.scrapFeedUUIDs
        self.signupDate = userAPIModel.signupDate
        self.updateDate = userAPIModel.updateDate
        self.isPushOn = userAPIModel.isPushOn
    }

    /// Guest 생성을 위한 이니셜라이저
    /// - Parameters:
    ///   - userUUID: 로그인을 통해 얻은 userUUID
    ///   - nickname: 게스트 닉네임
    ///
    init (userUUID: String, nickname: String) {
        self.userUUID = userUUID
        self.nickname = nickname
        self.profileImageURL = ""
        self.domain = .guest
        self.camperID = ""
        self.ordinalNumber = 7
        self.blogURL = ""
        self.blogTitle = ""
        self.scrapFeedUUIDs = []
        self.signupDate = Date()
        self.updateDate = Date(timeIntervalSince1970: 0)
        self.isPushOn = false
    }

    var toFeedWriter: FeedWriter {
        return FeedWriter(
            userUUID: self.userUUID,
            nickname: self.nickname,
            camperID: self.camperID,
            ordinalNumber: self.ordinalNumber,
            domain: self.domain,
            profileImageURL: self.profileImageURL,
            blogTitle: self.blogTitle
        )
    }
}
