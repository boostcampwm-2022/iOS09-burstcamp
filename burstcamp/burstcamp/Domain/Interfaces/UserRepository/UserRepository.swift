//
//  UserRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol UserRepository {
    func saveUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
    func removeUser(_ user: User) async throws
    func saveFCMToken(_ token: String, to userUUID: String) async throws
}
