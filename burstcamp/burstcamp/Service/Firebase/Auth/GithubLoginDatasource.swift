//
//  GithubLoginDatasource.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class GithubLoginDatasource {

    private let githubAPIKeyManager: GithubAPIKeyManager
    private let decoder = JSONDecoder()

    init(githubAPIKeyManager: GithubAPIKeyManager) {
        self.githubAPIKeyManager = githubAPIKeyManager
    }

    convenience init() {
        self.init(githubAPIKeyManager: GithubAPIKeyManager())
    }

    func requestGithubToken(code: String) async throws -> GithubToken {
        let urlString = "https://github.com/login/oauth/access_token"

        guard let githubAPIKey = githubAPIKeyManager.githubAPIKey
        else {
            throw GithubLoginDataSourceError.noAPIKey
        }

        let bodyInfos: [String: String] = [
            "client_id": githubAPIKey.clientID,
            "client_secret": githubAPIKey.clientSecret,
            "code": code
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyInfos)
        else { throw GithubLoginDataSourceError.bodyEncode }

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationJSON.keyValue
        ]

        let responseData = try await URLSessionService.request(
            urlString: urlString,
            httpMethod: .POST,
            httpHeaders: httpHeaders,
            httpBody: bodyData
        )

        return try decoder.decode(GithubToken.self, from: responseData)
    }

    func getGithubUserInfo(token: String) async throws -> GithubUser {
        let urlString = "https:/api.github.com/user"

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationVNDGithubJSON.keyValue,
            HTTPHeader.authorizationBearer(token: token).keyValue
        ]

        let responseData = try await URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return try decoder.decode(GithubUser.self, from: responseData)
    }

    func getOrganizationMembership(nickname: String, token: String) async throws -> GithubMembership {
        let urlString = "https://api.github.com/orgs/boostcampwm-2022/memberships/\(nickname)"

        let httpHeaders = [
            HTTPHeader.contentTypeApplicationJSON.keyValue,
            HTTPHeader.acceptApplicationVNDGithubJSON.keyValue,
            HTTPHeader.authorizationBearer(token: token).keyValue
        ]

        let responseData = try await URLSessionService.request(
            urlString: urlString,
            httpMethod: .GET,
            httpHeaders: httpHeaders
        )

        return try decoder.decode(GithubMembership.self, from: responseData)
    }
}
