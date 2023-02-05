//
//  UserRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol UserRepository {
    func fetchUser(_ userUUID: String) async throws -> User
    func saveUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
    func updateUserPushState(userUUID: String, isPushOn: Bool) async throws
    func removeUser(_ user: User) async throws
    func saveFCMToken(_ token: String, to userUUID: String) async throws

    func updateBlog(with signUpUserUUID: String, blogURL: String) async throws

    func saveGuest(userUUID: String) async throws -> User
    func isNicknameExist(_ nickname: String) async throws -> Bool
}
