//
//  String+toSHA.swift
//  burstcamp
//
//  Created by youtak on 2023/01/30.
//

import CryptoKit
import Foundation

extension String {

    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
