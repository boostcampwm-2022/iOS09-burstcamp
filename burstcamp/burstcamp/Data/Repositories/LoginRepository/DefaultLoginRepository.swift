//
//  DefaultLoginRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultLoginRepository: LoginRepository {

    private let bcFirebaseAuthService: BCFirebaseAuthService
    private let githubLoginDataSource: GithubLoginDatasource

    init(bcFirebaseAuthService: BCFirebaseAuthService, githubLoginDataSource: GithubLoginDatasource) {
        self.bcFirebaseAuthService = bcFirebaseAuthService
        self.githubLoginDataSource = githubLoginDataSource
    }

    func isLoggedIn() throws -> Bool {
        return try !bcFirebaseAuthService.getCurrentUserUid().isEmpty
    }

    func login(code: String) async throws -> String {
        let userNickname = try await authorizeBoostcamp(code: code)
        return userNickname
    }

    private func authorizeBoostcamp(code: String) async throws -> String {
        let githubToken = try await githubLoginDataSource.requestGithubToken(code: code)
        let githubUser = try await githubLoginDataSource.getGithubUserInfo(token: githubToken.accessToken)
        _ = try await githubLoginDataSource.getOrganizationMembership(
            nickname: githubUser.login,
            token: githubToken.accessToken
        )
        return githubUser.login
    }
}
