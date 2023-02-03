//
//  BCFirebaseFunctionService.swift
//  burstcamp
//
//  Created by youtak on 2023/01/16.
//

import Foundation

import FirebaseFunctions

public final class BCFirebaseFunctionService {

    private var functions: Functions

    public init(functions: Functions) {
        self.functions = functions
    }
    
    public convenience init() {
        let functions = Functions.functions()
        self.init(functions: functions)
    }

    public func getBlogTitle(link: String) async throws -> String {
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

    public func deleteUser(userUUID: String) async throws -> Bool {
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

    public func updateUserDB(user: UserAPIModel) async throws {
        // TODO: 유저 업데이트 함수 호출
        debugPrint("유저 DB 업데이트 팡숀")
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
