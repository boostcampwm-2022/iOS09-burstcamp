//
//  FetchingState.swift
//  BCFetcher
//
//  Created by SEUNGMIN OH on 2022/12/08.
//

import Foundation

public enum Status<FetchingError: Swift.Error> {
    case loading
    case failure(_ error: FetchingError)
    case success
    case alreadyLatest
}
