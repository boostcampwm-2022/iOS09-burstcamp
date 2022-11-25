//
//  FireStoreService.swift
//  Eoljuga
//
//  Created by neuli on 2022/11/17.
//

import Combine
import Foundation

final class FireStoreService {

    // User 저장

    static func save(user: User)
    -> AnyPublisher<User, NetworkError> {
        let baseURL = [
            FireStoreURL.baseURL,
            FireStoreURL.documentURL,
            FireStoreCollection.user.path
        ].joined()

        return URLSessionService.request(
            urlString: baseURL,
            httpMethod: .POST,
            httpHeaders: [(key: "Content-Type", value: "text/plain")],
            queryItems: [URLQueryItem(name: QueryParameter.documentID, value: user.userUUID)],
            httpBody: UserQuery.insert(user: user)
        )
        .decode(type: DocumentResult.self, decoder: JSONDecoder())
        .mapError { _ in NetworkError.responseDecoingError }
        .map { documentResult in
            let userDTO = documentResult.fields
            return userDTO.toUser()
        }
        .eraseToAnyPublisher()
    }

    // userUUID로 User 가져오기

    static func fetchUser(by userUUID: String)
    -> AnyPublisher<User, NetworkError> {
        let baseURL = [
            FireStoreURL.baseURL,
            FireStoreURL.documentURL,
            FireStoreURL.runQuery
        ].joined()

        return URLSessionService.request(
            urlString: baseURL,
            httpMethod: .POST,
            httpHeaders: [(key: "Content-Type", value: "text/plain")],
            httpBody: UserQuery.select(by: userUUID)
        )
        .decode(type: [FireStoreResult].self, decoder: JSONDecoder())
        .mapError { _ in NetworkError.responseDecoingError }
        .map { fireStoreResult in
            let userDTO = fireStoreResult[0].document.fields
            return userDTO.toUser()
        }
        .eraseToAnyPublisher()
    }
}
