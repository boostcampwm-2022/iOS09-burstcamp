//
//  FireStorageError.swift
//  burstcamp
//
//  Created by neuli on 2022/12/02.
//

import Foundation

enum FireStorageError: LocalizedError {
    case dataUploadError
    case URLDownloadError
}

extension FireStorageError: CategorizedError {
    var category: ErrorCategory {
        return .retryable
    }
}

extension FireStorageError {
    var errorDescription: String? {
        switch self {
        case .dataUploadError: return "데이터 업로드 중 에러가 발생했습니다."
        case .URLDownloadError: return "서버에서 URL을 받아오던 중 에러가 발생했습니다."
        }
    }
}
