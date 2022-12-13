//
//  FireStorageService.swift
//  burstcamp
//
//  Created by neuli on 2022/11/29.
//

import Combine
import UIKit

import FirebaseStorage

final class FireStorageService {

    private static let storagePath = Storage.storage()

    static func save(image: UIImage) -> AnyPublisher<String, Error> {
        guard let imageData = image.jpegData(compressionQuality: 0.2)
        else {
            return Fail(error: ConvertError.invalidImageConvert)
                .eraseToAnyPublisher()
        }

        let filename = UserManager.shared.user.userUUID
        let ref = storagePath.reference(withPath: "/images/\(filename)")

        return Future<String, Error> { promise in
            ref.putData(imageData) { _, error in
                if error != nil {
                    promise(.failure(FireStorageError.dataUploadError))
                }
                ref.downloadURL { url, error in
                    if error != nil {
                        promise(.failure(FireStorageError.URLDownloadError))
                    }
                    if let url = url {
                        let imageURL = url.absoluteString
                        promise(.success(imageURL))
                    } else {
                        promise(.failure(FireStorageError.URLDownloadError))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
