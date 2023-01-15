//
//  DefaultLoginRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultLoginRepository: LoginRepository {

    private let githubLoginDataSource: GithubLoginDatasource

    init(githubLoginDataSource: GithubLoginDatasource) {
        self.githubLoginDataSource = githubLoginDataSource
    }

    func authorizeBoostcamp(code: String) throws {
        Task {
            do {
                let githubToken = try await githubLoginDataSource.requestGithubToken(code: code)
                let githubUser = try await githubLoginDataSource.getGithubUserInfo(token: githubToken.accessToken)
                let githubMembership = try await githubLoginDataSource.getOrganizationMembership(
                    nickname: githubUser.login,
                    token: githubToken.accessToken
                )
                // githubMemebership 있으면 성공
//                return true
            } catch {
            }
        }
    }

    func isLoggedIn() throws -> Bool {
        return false
    }

    func login() throws {
    }

    func withDrawal() throws {
    }
}
