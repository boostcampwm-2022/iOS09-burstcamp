//
//  DefaultImageRepository.swift
//  burstcamp
//
//  Created by youtak on 2023/01/19.
//

import Foundation

import BCFirebase

final class DefaultImageRepository: ImageRepository {

    private let bcFirestorageService: BCFireStorageService

    init(bcFirestorageService: BCFireStorageService) {
        self.bcFirestorageService = bcFirestorageService
    }

    func saveProfileImage(imageData: Data, userUUID: String) async throws -> String {
        return try await bcFirestorageService.saveProfileImage(imageData: imageData, to: userUUID)
    }

    func deleteProfileImage(userUUID: String) async throws {
        try await bcFirestorageService.deleteProfileImage(userUUID: userUUID)
    }
}
