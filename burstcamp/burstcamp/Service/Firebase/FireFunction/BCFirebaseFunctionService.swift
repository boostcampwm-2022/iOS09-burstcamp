//
//  BCFirebaseFunctionService.swift
//  burstcamp
//
//  Created by youtak on 2023/01/16.
//

import Foundation

import FirebaseFunctions

final class BCFirebaseFunctionService {

    private var functions: Functions

    init(functions: Functions = Functions.functions()) {
        self.functions = functions
    }

    func getBlogTitle(link: String) async throws -> String {
        let result = try await functions
            .httpsCallable(FunctionField.fetchBlogTitle)
            .call([FunctionField.blogURL: link])

        if let data = result.data as? [String: Any],
           let blogTitle = data[FunctionField.blogTitle] as? String {
            return blogTitle
        } else {
            throw FirebaseFunctionError.getBlogTitle
        }
    }

    func deleteUser(userUUID: String) async throws -> Bool {
        let result = try await functions
            .httpsCallable(FunctionField.deleteUser)
            .call([FunctionField.userUUID: userUUID])

        if let data = result.data as? [String: Any],
           let isFinish = data[FunctionField.isFinish] as? Bool {
            return isFinish
        } else {
            throw FirebaseFunctionError.deleteUser
        }
    }
}

extension BCFirebaseFunctionService {
    enum FunctionField {
        static let fetchBlogTitle = "fetchBlogTitle"
        static let deleteUser = "deleteUser"
        static let blogURL = "blogURL"
        static let blogTitle = "blogTitle"
        static let userUUID = "userUUID"
        static let isFinish = "isFinish"
    }
}
