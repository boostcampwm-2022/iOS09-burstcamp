//
//  ValidationResult.swift
//  burstcamp
//
//  Created by neuli on 2022/11/23.
//

import Foundation

enum MyPageEditValidationResult {
    case validationOK
    case nicknameError
    case blogLinkError

    var message: String {
        switch self {
        case .validationOK: return "프로필 수정이 완료되었어요."
        case .nicknameError: return "닉네임을 다시 확인해주세요."
        case .blogLinkError: return "블로그 주소를 다시 확인해주세요."
        }
    }
}
