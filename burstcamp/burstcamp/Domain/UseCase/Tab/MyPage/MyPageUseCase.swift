//
//  MyPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol MyPageUseCase {
    func withdrawal(code: String) async throws
    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws
    func updateUserDarkModeState(appearance: Appearance)
}
