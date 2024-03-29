//
//  MyPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol MyPageUseCase {
    func withdrawalWithGithub(code: String) async throws
    func withdrawalWithApple(idTokenString: String, nonce: String) async throws

    func canUpdateMyInfo() -> Bool
    func getNextUpdateDate() -> Date

    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws
    func updateUserDarkModeState(appearance: Appearance)
    func updateLocalUser(_ user: User)
}
