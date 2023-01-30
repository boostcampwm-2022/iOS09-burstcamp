//
//  LoginRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol LoginRepository {
    func isLoggedIn() -> Bool
    func login(code: String) async throws -> (userNickname: String, userUUID: String)
    func withdrawal(code: String) async throws -> Bool
    func loginWithApple(idTokenString: String, nonce: String) async throws -> String
    func withdrawalWithApple(idTokenString: String, nonce: String) async throws
}
