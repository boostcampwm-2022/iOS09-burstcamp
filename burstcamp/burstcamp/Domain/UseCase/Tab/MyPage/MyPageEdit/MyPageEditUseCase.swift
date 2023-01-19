//
//  MyPageEditUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol MyPageEditUseCase {
    func setUserNickname(_ nickname: String)
    func setUserBlogURL(_ blogURL: String)
    func validateResult() -> MyPageEditValidationResult
    func updateUser() async throws
}
