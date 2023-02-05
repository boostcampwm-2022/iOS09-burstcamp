//
//  ImageRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/19.
//

import Foundation

protocol ImageRepository {
    func saveProfileImage(imageData: Data, userUUID: String) async throws -> String
    func deleteProfileImage(userUUID: String) async throws
}
