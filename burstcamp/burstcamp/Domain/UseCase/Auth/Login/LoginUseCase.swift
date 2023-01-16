//
//  LoginUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol LoginUseCase {
    func isLoggedIn() throws -> Bool
    func autoLogin() throws
    func login(code: String) throws
    func signOut(code: String) throws
    func authorizeBoostcamp(code: String) throws -> Bool
}
