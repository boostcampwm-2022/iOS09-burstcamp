//
//  FireStoreResult.swift
//  burstcamp
//
//  Created by neuli on 2022/11/25.
//

import Foundation

struct FireStoreResult<T: Decodable>: Decodable {
    let document: T
}
