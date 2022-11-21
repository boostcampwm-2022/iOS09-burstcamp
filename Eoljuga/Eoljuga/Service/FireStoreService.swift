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
        let endPoint = [
            FireStoreURL.baseURL,
            FireStoreURL.documentURL,
            FireStoreCollection.user.path,
            QueryParameter.documentID,
            user.userUUID
        ].joined()

        guard let url = URL(string: endPoint)
        else { return Fail(error: NetworkError.urlError)
            .eraseToAnyPublisher() }

        let saveUserRequest = URLSessionService.makeRequest(
            url: url,
            httpMethod: .POST,
            httpBody: UserQuery.saveQuery(user: user)
        )

        return URLSessionService
            .request(with: saveUserRequest)
            .decode(type: DocumentResult.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodeError }
            .map { documentResult in
                let userDTO = documentResult.fields
                return userDTO.toUser()
            }
            .eraseToAnyPublisher()
    }

    // userUUID로 User 가져오기

    static func fetchUser(by userUUID: String)
    -> AnyPublisher<User, NetworkError> {
        let endPoint = [
            FireStoreURL.baseURL,
            FireStoreURL.documentURL,
            FireStoreURL.runQuery
        ].joined()

        guard let url = URL(string: endPoint)
        else { return Fail(error: NetworkError.urlError)
            .eraseToAnyPublisher() }

        let fetchUserRequest = URLSessionService.makeRequest(
            url: url,
            httpMethod: .POST,
            httpBody: UserQuery.selectUser(by: userUUID)
        )

        return URLSessionService
            .request(with: fetchUserRequest)
            .decode(type: [FireStoreResult].self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodeError }
            .map { fireStoreResult in
                let userDTO = fireStoreResult[0].document.fields
                return userDTO.toUser()
            }
            .eraseToAnyPublisher()
    }
}
