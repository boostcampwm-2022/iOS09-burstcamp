//
//  ImageCacheError.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Foundation

enum ImageCacheError: LocalizedError {
    case imageURLErrror
    case notModifiedImage
    case network(error: NetworkError)
    case unKnownError
}

extension ImageCacheError {
    var errorDescription: String? {
        switch self {
        case .imageURLErrror: return "이미지 URL 변환 중 에러가 발생했습니다"
        case .notModifiedImage: return "이미지가 동일합니다 (etag 동일)"
        case .network(let error): return "\(error.errorDescription)"
        case .unKnownError: return "알 수 없는 네트워크 에러가 발생했습니다."
        }
    }
}
