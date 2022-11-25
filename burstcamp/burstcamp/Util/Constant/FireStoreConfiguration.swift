//
//  FireStoreConfiguration.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Foundation

enum FireStoreURL {
    static let baseURL = "https://firestore.googleapis.com/v1/projects/eoljuga-9b868"
    static let documentURL = "/databases/(default)/documents"
    static let runQuery = ":runQuery"
    static let commit = ":commit"
}

enum FireStoreCollection: String {
    case user = "User"
    case blog = "Blog"
    case feed = "Feed"

    var path: String {
        switch self {
        case .user: return "/\(self.rawValue)"
        case .blog: return "/\(self.rawValue)"
        case .feed: return "/\(self.rawValue)"
        }
    }
}

enum FireStoreField {
    static let fields = "fields"
}

enum QueryParameter {
    static let documentID = "documentId"
}
