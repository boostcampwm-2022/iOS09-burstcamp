//
//  NetworkError.swift
//  FireStoreTest
//
//  Created by neuli on 2022/11/20.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int)
    case urlError
    case decodeError
    case unknown(_ message: String = "")
}
