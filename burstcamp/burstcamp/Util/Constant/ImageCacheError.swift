//
//  ImageCacheError.swift
//  burstcamp
//
//  Created by neuli on 2022/11/27.
//

import Foundation

enum ImageCacheError: Error {
    case invalidationImageURL
    case invalidConversionFromDataToImage
    case diskImageDataNil
    case notExistImageInDisk
    case notModifiedImage
    case network(error: NetworkError)
    case unknownerror
}
