//
//  TimeInterval+.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

extension TimeInterval {

    // MARK: - Computed Type Properties

    internal static var secondsPerDay: Double { return 24 * 60 * 60 }
    internal static var secondsPerHour: Double { return 60 * 60 }
    internal static var secondsPerMinute: Double { return 60 }

    // MARK: - Type Methods

    public static func days(before value: Double) -> TimeInterval {
        return -(value * secondsPerDay)
    }

    public static func hours(before value: Double) -> TimeInterval {
        return -(value * secondsPerHour)
    }

    public static func minutes(before value: Double) -> TimeInterval {
        return -(value * secondsPerMinute)
    }

    public static func seconds(before value: Double) -> TimeInterval {
        return value
    }

    public static func before(
        seconds: Double,
        minutes: Double = 0,
        hours: Double = 0,
        days: Double = 0
    ) -> TimeInterval {
        return -(days*secondsPerDay + hours*secondsPerHour + minutes*secondsPerMinute + seconds)
    }
}
