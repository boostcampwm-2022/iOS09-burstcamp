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

    static func save(image: UIImage) -> AnyPublisher<String, FireStorageError> {
        guard let imageData = image.jpegData(compressionQuality: 1.0)
        else {
            return Fail(error: FireStorageError.invalidConversionFromImageToData)
                .eraseToAnyPublisher()
        }

        let filename = UserManager.shared.user.userUUID
        let ref = storagePath.reference(withPath: "/images/\(filename)")

        return Future<String, FireStorageError> { promise in
            ref.putData(imageData) { _, error in
                if error != nil {
                    promise(.failure(.failPutDataToStorage))
                }
                ref.downloadURL { url, error in
                    if error != nil {
                        promise(.failure(.failDownloadURL))
                    }
                    if let url = url {
                        let imageURL = url.absoluteString
                        promise(.success(imageURL))
                    } else {
                        promise(.failure(.failDownloadURL))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
