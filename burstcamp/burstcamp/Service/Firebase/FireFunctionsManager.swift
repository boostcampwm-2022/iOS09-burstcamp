//
//  RSSManager.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import Foundation

import FirebaseFunctions

struct FireFunctionsManager {

    static var functions = Functions.functions()

    static func blogTitle(link: String) -> Future<String, NetworkError> {
        return Future<String, NetworkError> { promise in
            functions
                .httpsCallable("fetchBlogTitle")
                .call(["blogURL": link]) { result, error in
                    if error != nil {
                        promise(.failure(NetworkError.unknownError))
                    }
                    if let data = result?.data as? [String: Any],
                       let blogTitle = data["blogTitle"] as? String {
                        promise(.success(blogTitle))
                    }
                    promise(.failure(NetworkError.unknownError))
                }
        }
    }
}
