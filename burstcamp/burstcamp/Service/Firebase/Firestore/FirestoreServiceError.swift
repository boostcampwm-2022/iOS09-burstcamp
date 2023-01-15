//
//  FirestoreServiceError.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

enum FirestoreServiceError: Error {
    case getCollection
    case getDocument
    case lastCollectionError
    case addListenerFail
    case errorCastingFail(message: String)
}
