//
//  MyPageEditUseCase.swift
//  burstcamp
//
//  Created by youtak on 2023/01/14.
//

import Foundation

protocol MyPageEditUseCase {
    func isValidNickname(_ nickname: String) async throws -> MyPageEditNicknameValidation
    func isValidBlogURL(_ blogURL: String) -> MyPageEditBlogValidation

    func updateUser(user: User, imageData: Data?) async throws
}
