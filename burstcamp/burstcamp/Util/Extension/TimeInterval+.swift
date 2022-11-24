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
    /// - Returns: The time in days using the `TimeInterval` type.
    public static func days(_ value: Double) -> TimeInterval {
        return value * secondsPerDay
    }

    /// - Returns: The time in hours using the `TimeInterval` type.
    public static func hours(_ value: Double) -> TimeInterval {
        return value * secondsPerHour
    }

    /// - Returns: The time in minutes using the `TimeInterval` type.
    public static func minutes(_ value: Double) -> TimeInterval {
        return value * secondsPerMinute
    }

    public static func interval(days: Double, hours: Double, minute: Double) -> TimeInterval {
        return days * secondsPerDay + hours * secondsPerHour + minute * secondsPerMinute
    }
}
