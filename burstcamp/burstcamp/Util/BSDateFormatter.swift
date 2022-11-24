//
//  DateFormatter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct BSDateFormatter {

    static var secondsPerYear: Double { return 365 * 24 * 60 * 60}
    static var secondsPerWeek: Double { return 7 * 24 * 60 * 60 }
    static var secondsPerDay: Double { return 24 * 60 * 60 }
    static var secondsPerHour: Double { return 60 * 60 }
    static var secondsPerMinute: Double { return 60 }

    static func relativeTimeString(pubDate: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(pubDate)

        switch interval {
        case 0..<secondsPerMinute: return interval.toJustString
        case secondsPerMinute..<secondsPerHour: return interval.toMinuteString
        case secondsPerHour..<secondsPerDay: return interval.toHourString
        case secondsPerDay..<secondsPerWeek: return interval.toDayString
        case .secondsPerWeek..<secondsPerYear: return pubDate.monthDateFormatString
        default: return pubDate.yearMonthDateFormatString
        }
    }
}
