//
//  FirestoreServiceError.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

public enum FirestoreServiceError: Error, Equatable {
    case getCollection
    case getDocument
    case lastCollection
    case addListenerFail
    case errorCastingFail(message: String)
    case batch
    case lastFetch
    case userListener
    case scrapIsEmpty
}
