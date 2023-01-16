//
//  DefaultMyPageUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

final class DefaultMyPageUseCase: MyPageUseCase {

    private let loginRepository: LoginRepository

    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }

    func withdrawal(code: String) async throws {
        let isSuccess = try await loginRepository.withdrawal(code: code)
        if !isSuccess { throw MyPageUseCaseError.withdrawal }
    }
}
