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

    static let fetchBlogTitle = "fetchBlogTitle"
    static let deleteUser = "deleteUser"
    static let blogTitleField = "blogTitle"
    static let userUUIDFeild = "userUUID"

    static func blogTitle(link: String) -> Future<String, NetworkError> {
        return Future<String, NetworkError> { promise in
            functions
                .httpsCallable(fetchBlogTitle)
                .call([blogTitleField: link]) { result, error in
                    if error != nil {
                        promise(.failure(NetworkError.unknownError))
                    }
                    if let data = result?.data as? [String: Any],
                       let blogTitle = data[blogTitleField] as? String {
                        promise(.success(blogTitle))
                    }
                    promise(.failure(NetworkError.unknownError))
                }
        }
    }

    static func deleteUser(userUUID: String) -> Future<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            functions
                .httpsCallable(deleteUser)
                .call([userUUIDFeild: userUUID]) { result, error in
                    if error != nil {
                        promise(.failure(NetworkError.unknownError))
                    }
                    if let data = result?.data as? [String: Any],
                       let isFinish = data[userUUIDFeild] as? Bool {
                        promise(.success(isFinish))
                    }
                    promise(.failure(NetworkError.unknownError))
                }
        }
    }
}
