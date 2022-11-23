//
//  TimeFormatting.swift
//  burstcamp
//
//  Created by youtak on 2022/11/23.
//

import Foundation

import Firebase

struct DateFormatter {

    static func time() {
        let timestamp = Timestamp()
        let now = timestamp.dateValue()
        print(now)
    }
}
