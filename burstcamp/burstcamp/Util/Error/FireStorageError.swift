//
//  FireStorageError.swift
//  burstcamp
//
//  Created by neuli on 2022/12/02.
//

import Foundation

enum FireStorageError: Error {
    case invalidConversionFromImageToData
    case failPutDataToStorage
    case failDownloadURL
}
