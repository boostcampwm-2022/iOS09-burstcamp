//
//  LoginRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol LoginRepository {
    func authorizeBoostcamp(code: String) async throws -> GithubMembership
    func isLoggedIn() throws -> Bool
    func login() throws
    func withDrawal() throws
}
