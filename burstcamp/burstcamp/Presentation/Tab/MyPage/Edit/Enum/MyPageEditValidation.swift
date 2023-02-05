//
//  ValidationResult.swift
//  burstcamp
//
//  Created by neuli on 2022/11/23.
//

import Foundation

// MARK: - 닉네임 유효성
enum MyPageEditNicknameValidation {
    case success
    case regexError
    case duplicateError
}

// MARK: - 최종 유효성

enum MyPageEditBlogValidation {
    case success
    case regexError
}
