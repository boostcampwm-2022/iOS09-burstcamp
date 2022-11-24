//
//  TimeInterval+.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

extension TimeInterval {

    // MARK: - Computed Type Properties

    static var secondsPerWeek: Double { return 7 * 24 * 60 * 60 }
    static var secondsPerDay: Double { return 24 * 60 * 60 }
    static var secondsPerHour: Double { return 60 * 60 }
    static var secondsPerMinute: Double { return 60 }

    static func before(
        seconds: Double = 0,
        minutes: Double = 0,
        hours: Double = 0,
        days: Double = 0
    ) -> TimeInterval {
        return -(days*secondsPerDay + hours*secondsPerHour + minutes*secondsPerMinute + seconds)
    }

    // MARK: - computed properties

    var toJustString: String {
        return "방금 전"
    }

    var toMinuteString: String {
        let minutes = Int(self/TimeInterval.secondsPerMinute)
        return "\(minutes)분 전"
    }

    var toHourString: String {
        let hours = Int(self/TimeInterval.secondsPerHour)
        return "\(hours)시간 전"
    }

    var toDayString: String {
        let days = Int(self/TimeInterval.secondsPerDay)
        return "\(days)일 전"
    }
}
