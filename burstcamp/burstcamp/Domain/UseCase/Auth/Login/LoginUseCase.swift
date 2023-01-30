//
//  LoginUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol LoginUseCase {
    func checkIsExist(userUUID: String) async throws -> Bool
    func isLoggedIn() -> Bool

    func loginWithGithub(code: String) async throws -> (userNickname: String, userUUID: String)

    func loginWithApple(idTokenString: String, nonce: String) async throws -> String
    func withdrawalWithApple(idTokenString: String, nonce: String) async throws
}
