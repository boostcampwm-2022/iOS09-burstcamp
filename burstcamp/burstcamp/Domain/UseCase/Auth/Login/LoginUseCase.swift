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
    func login(code: String) async throws ->  (userNickname: String, userUUID: String)
}
