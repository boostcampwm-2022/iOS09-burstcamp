//
//  URLSessionService.swift
//  FireStoreTest
//
//  Created by neuli on 2022/11/20.
//

import Combine
import Foundation

final class URLSessionService {

    private static func makeRequest(
        urlString: String,
        httpMethod: HttpMethod,
        httpHeaders: [(key: String, value: String)]?,
        queryItems: [URLQueryItem],
        httpBody: Data?
    ) throws -> URLRequest {
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems = queryItems

        guard let url = urlComponent?.url else { throw NetworkError.invalidURLError }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        httpHeaders?.forEach { httpHeader in
            request.addValue(httpHeader.value, forHTTPHeaderField: httpHeader.key)
        }
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }

        return request
    }

    static func request(
        urlString: String,
        httpMethod: HttpMethod,
        httpHeaders: [(key: String, value: String)]? = nil,
        queryItems: [URLQueryItem] = [],
        httpBody: Data? = nil
    ) -> AnyPublisher<Data, NetworkError> {

        guard let request = try? makeRequest(
            urlString: urlString,
            httpMethod: httpMethod,
            httpHeaders: httpHeaders,
            queryItems: queryItems,
            httpBody: httpBody
        )
        else {
            return Fail(error: NetworkError.unknownError)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299: return data
                    default: throw self.makeNetworkError(errorCode: response.statusCode)
                    }
                }
                return data
            }
            .mapError { error in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }

    static func request(
        urlString: String,
        httpMethod: HttpMethod,
        httpHeaders: [(key: String, value: String)]? = nil,
        queryItems: [URLQueryItem] = [],
        httpBody: Data? = nil
    ) async throws -> Data {
        guard let request = try? makeRequest(
            urlString: urlString,
            httpMethod: httpMethod,
            httpHeaders: httpHeaders,
            queryItems: queryItems,
            httpBody: httpBody
        )
        else {
            throw URLSessionServiceError.makeRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLSessionServiceError.responseCode
        }
        return data
    }

    private static func makeNetworkError(errorCode: Int) -> NetworkError {
        return .init(rawValue: errorCode) ?? .unknownError
    }
}
