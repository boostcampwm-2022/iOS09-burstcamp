//
//  DateFormatter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/23.
//

import Foundation

struct DateFormatter {

    static func time(pubDate: Date) -> String {
        let now = Date()
        let interval = Int(now.timeIntervalSince(pubDate))
        switch interval {
        case 0..<60: return "방금 전"
        case 60..<3600: return "\(interval/60)분 전"
        case 3600..<86400: return "\(interval/360)시간 전"
        case 86400..<604800: return "\(interval/604800)일 전"
        default: return "특정 날짜"
        }
    }
}
