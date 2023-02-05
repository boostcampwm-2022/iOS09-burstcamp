//
//  FireStorageError.swift
//  burstcamp
//
//  Created by neuli on 2022/12/02.
//

import Foundation

public enum FireStorageError: LocalizedError {
    case userSignUp
    case dataUpload
    case URLDownload
    case deleteError
}

extension FireStorageError {
    public var errorDescription: String? {
        switch self {
        case .userSignUp: return "DB에 블로그 업데이트 중 에러가 발생했습니다"
        case .dataUpload: return "데이터 업로드 중 에러가 발생했습니다."
        case .URLDownload: return "서버에서 URL을 받아오던 중 에러가 발생했습니다."
        case .deleteError: return "서버에서 데이터 삭제 중 에러가 발생했습니다."
        }
    }
}
