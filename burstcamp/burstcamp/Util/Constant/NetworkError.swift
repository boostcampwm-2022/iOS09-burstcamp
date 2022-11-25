//
//  NetworkError.swift
//  FireStoreTest
//
//  Created by neuli on 2022/11/20.
//

import Foundation

enum NetworkError: Int, Error, CustomStringConvertible {

    var description: String { errorDescription }

    case responseDecoingError
    case queryEncodingError
    case decodingError
    case encodingError
    case invalidURLError
    case invalidDataError
    case unknownError
    case invalidRequestError = 400
    case authenticationError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
    case notSupportedError = 501
    case badGatewayError = 502
    case invalidServiceError = 503

    var errorDescription : String {
        switch self {
        case .responseDecoingError: return "RESPONSE_DECODING_ERROR"
        case .queryEncodingError: return "QUERY_ENCODING_ERROR"
        case .decodingError: return "DECODING_ERROR"
        case .encodingError: return "ENCODING_ERROR"
        case .invalidURLError: return " INVALID_URL_ERROR"
        case .invalidDataError: return "INVALID_DATA_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .invalidRequestError: return "400:INVALID_URL_ERROR"
        case .authenticationError: return "401:AUTHENTICATION_FAILURE_ERROR"
        case .forbiddenError: return "403:AUTHENTICATION_FAILURE_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        case .notAllowedHTTPMethodError: return "405:NOT_ALLOWED_HTTP_METHOD_ERROR"
        case .timeoutError: return "408:TIMEOUT_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .notSupportedError: return "501:NOT_SUPPORTED_ERROR"
        case .badGatewayError: return "502:BAD_GATEWAY_ERROR"
        case .invalidServiceError: return "503:INVALID_SERVICE_ERROR"
        }
    }
}
