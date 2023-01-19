//
//  FireStorageService.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import UIKit

import FirebaseStorage

final class BCFireStorageService {

    private let storagePath: Storage

    init(storagePath: Storage) {
        self.storagePath = storagePath
    }

    convenience init() {
        self.init(storagePath: Storage.storage())
    }

    func saveProfileImage(imageData: Data, to userUUID: String) async throws -> String {
        let ref = storagePath.reference(withPath: "/images/profile/\(userUUID)")

        do {
            _ = try await ref.putDataAsync(imageData)
        } catch {
            throw FireStorageError.dataUpload
        }

        do {
            let imageURL = try await ref.downloadURL().absoluteString
            return imageURL
        } catch {
            throw FireStorageError.URLDownload
        }
    }

    func deleteProfileImage(userUUID: String) async throws {
        let ref = storagePath.reference(withPath: "/images/profile/\(userUUID)")
        do {
            try await ref.delete()
        } catch {
            throw FireStorageError.deleteError
        }
    }
}
