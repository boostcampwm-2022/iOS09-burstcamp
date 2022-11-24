//
//  DateFormatter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/24.
//

import Foundation

struct BCDateFormatter {

    static var secondsPerYear: Double { return 365 * 24 * 60 * 60}
    static var secondsPerWeek: Double { return 7 * secondsPerDay }
    static var secondsPerDay: Double { return 24 * secondsPerHour }
    static var secondsPerHour: Double { return 60 * secondsPerMinute }
    static var secondsPerMinute: Double { return 60 }

    /// 시간 차이에 따라 String을 리턴해주는 함수
    /// - Parameters:
    ///   - target:블로그 발행시간
    ///   - standard: 기준 시간. default 값은 현재임
    /// - Returns: String 값
    /// @discussion
    /// - 방금 전 (59초까지)
    /// - 1분 전 ~ 59분 전
    /// - 1시간 전 ~ 23시간 전
    /// - 1일 전 ~ 6일 전
    /// - 1년 이전 : m월 d일 ex) 7월 18일 (월과 일 앞에 0붙이지 않음 07월, 05일 x)
    /// - 1년 이후 : yy.mm.dd ex) 21.10.25, 21.05.05 (월과 일 앞에 0붙임)
    static func relativeTimeString(for target: Date, relativeTo standard: Date = Date()) -> String {
        let interval = standard.timeIntervalSince(target)

        switch interval {
        case 0..<secondsPerMinute: return interval.toJustString
        case secondsPerMinute..<secondsPerHour: return interval.toMinuteString
        case secondsPerHour..<secondsPerDay: return interval.toHourString
        case secondsPerDay..<secondsPerWeek: return interval.toDayString
        case .secondsPerWeek..<secondsPerYear: return target.monthDateFormatString
        default: return target.yearMonthDateFormatString
        }
    }
}
