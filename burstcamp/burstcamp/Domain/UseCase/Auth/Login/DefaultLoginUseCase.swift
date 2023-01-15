//
//  DefaultLoginUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultLoginUseCase: LoginUseCase {
    func autoLogin() {
    }

    func login(code: String) {
        // Firebase 로그인

        // 로그인 안 됨 -> 부캠 인증
    }

    func authorizeBoostcamp(code: String) -> Bool {

        return false
    }
}
