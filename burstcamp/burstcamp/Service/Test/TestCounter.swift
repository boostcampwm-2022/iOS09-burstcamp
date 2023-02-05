//
//  TestCounter.swift
//  burstcamp
//
//  Created by youtak on 2023/01/27.
//

import Foundation

struct TestCounter {
    static var count = 0

    static func up() {
        count += 1
        print("Constraints 업데이트 수 : ", count)
    }
}
