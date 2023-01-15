//
//  GithubLoginDatasource.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class GithubLoginDatasource {

    private let githubAPIKeyManager: GithubAPIKeyManager

    init(githubAPIKeyManager: GithubAPIKeyManager) {
        self.githubAPIKeyManager = githubAPIKeyManager
    }

    convenience init() {
        self.init(githubAPIKeyManager: GithubAPIKeyManager())
    }

    func requestGithubToken(code: String) async throws -> GithubToken {

        return GithubToken(accessToken: "", scope: "", tokenType: "")
    }

    func getGithubUserInfo(token: String) async throws -> GithubUser {
        return GithubUser(login: "")
    }

    func getOrganizationMembership(nickname: String, token: String) async throws -> GithubMembership {
        return GithubMembership(role: "", user: MembershipUser(login: "", id: 0, nodeID: "", htmlURL: "", type: ""))
    }
}
