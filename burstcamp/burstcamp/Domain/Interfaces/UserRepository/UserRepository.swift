//
//  UserRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/15.
//

import Foundation

protocol UserRepository {
    func saveUser(_ user: User)
    func updateUser(_ user: User)
    func removeUser(_ user: User)
}
