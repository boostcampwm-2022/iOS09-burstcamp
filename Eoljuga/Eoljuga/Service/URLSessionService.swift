//
//  URLSessionService.swift
//  FireStoreTest
//
//  Created by neuli on 2022/11/20.
//

import Combine
import Foundation

final class URLSessionService {

    static func makeRequest(
        url: URL,
        httpMethod: HttpMethod,
        httpBody: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        return request
    }

    static func request(with request: URLRequest)
    -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        print(httpResponse.statusCode)
                        return data
                    default:
                        print(httpResponse.statusCode)
                        throw NetworkError.error(
                            statusCode: httpResponse.statusCode
                        )
                    }
                } else {
                    throw NetworkError.unknown
                }
            }
            .mapError { NetworkError.unknownMessage($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
