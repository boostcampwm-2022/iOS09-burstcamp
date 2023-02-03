//
//  FireStorageService.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import UIKit

import FirebaseStorage

public final class BCFireStorageService {

    private let storagePath: Storage

    public init(storagePath: Storage) {
        self.storagePath = storagePath
    }

    public convenience init() {
        self.init(storagePath: Storage.storage())
    }

    public func saveProfileImage(imageData: Data, to userUUID: String) async throws -> String {
        let ref = storagePath.reference(withPath: "images/profile/\(userUUID)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(imageData, metadata: metadata)
        let imageURL = try await ref.downloadURL().absoluteString
        return imageURL
    }

    public func deleteProfileImage(userUUID: String) async throws {
        let ref = storagePath.reference(withPath: "images/profile/\(userUUID)")
        try await ref.delete()
    }
}
