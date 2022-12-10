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

    private static var functions = Functions.functions()

    private static let fetchBlogTitle = "fetchBlogTitle"
    private static let deleteUser = "deleteUser"
    private static let blogTitleField = "blogTitle"
    private static let userUUIDField = "userUUID"
    private static let isFinishField = "isFinish"

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

    static func deleteUser(userUUID: String) -> AnyPublisher<Bool, NetworkError> {
        return Future<Bool, NetworkError> { promise in
            functions
                .httpsCallable(deleteUser)
                .call([userUUIDField: userUUID]) { result, error in
                    if error != nil {
                        promise(.success(false))
                    }
                    if let data = result?.data as? [String: Any],
                       let isFinish = data[isFinishField] as? Bool {
                        promise(.success(isFinish))
                    }
                    promise(.success(false))
                }
        }
        .eraseToAnyPublisher()
    }
}
