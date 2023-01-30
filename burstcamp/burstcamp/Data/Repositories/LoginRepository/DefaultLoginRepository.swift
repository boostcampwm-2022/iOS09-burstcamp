//
//  DefaultLoginRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

final class DefaultLoginRepository: LoginRepository {
    private let bcFirebaseAuthService: BCFirebaseAuthService
    private let bcFirebaseFunctionService: BCFirebaseFunctionService
    private let githubLoginDataSource: GithubLoginDatasource

    init(
        bcFirebaseAuthService: BCFirebaseAuthService,
        bcFirebaseFunctionService: BCFirebaseFunctionService,
        githubLoginDataSource: GithubLoginDatasource
    ) {
        self.bcFirebaseAuthService = bcFirebaseAuthService
        self.bcFirebaseFunctionService = bcFirebaseFunctionService
        self.githubLoginDataSource = githubLoginDataSource
    }

    func isLoggedIn() -> Bool {
        do {
            return try !bcFirebaseAuthService.getCurrentUserUid().isEmpty
        } catch {
            return false
        }
    }

    func loginWithGithub(code: String) async throws ->  (userNickname: String, userUUID: String) {
        let (userNickname, token) = try await authorizeBoostcamp(code: code)
        // auth로 로그인
        let userUUID = try await bcFirebaseAuthService.loginWithGithub(token: token)
        return (userNickname, userUUID)
    }

    func withdrawalWithGithub(code: String, userUUID: String) async throws -> Bool {
        let githubToken = try await githubLoginDataSource.requestGithubToken(code: code)
        try await bcFirebaseAuthService.withdrawalWithGithub(token: githubToken.accessToken)

        return try await bcFirebaseFunctionService.deleteUser(userUUID: userUUID)
    }

    /// 애플 로그인
    /// - Returns: user UUID
    func loginWithApple(idTokenString: String, nonce: String) async throws -> String {
        return try await bcFirebaseAuthService.loginWithApple(idTokenString: idTokenString, nonce: nonce)
    }

    func withdrawalWithApple(idTokenString: String, nonce: String, userUUID: String) async throws -> Bool {
        try await bcFirebaseAuthService.withdrawalWithApple(idTokenString: idTokenString, nonce: nonce)
        return try await bcFirebaseFunctionService.deleteUser(userUUID: userUUID)
    }

    private func authorizeBoostcamp(code: String) async throws -> (userNickname: String, token: String) {
        let githubToken = try await githubLoginDataSource.requestGithubToken(code: code)
        let githubUser = try await githubLoginDataSource.getGithubUserInfo(token: githubToken.accessToken)
        _ = try await githubLoginDataSource.getOrganizationMembership(
            nickname: githubUser.login,
            token: githubToken.accessToken
        )
        return (githubUser.login, githubToken.accessToken)
    }
}
