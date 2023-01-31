//
//  DateFormatter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/23.
//

import Foundation

extension Date {

    var monthDateFormatString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"

        return formatter.string(from: self)
    }

    var yearMonthDateFormatString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"

        return formatter.string(from: self)
    }

    // swiftlint: disable orphaned_doc_comment
    /// 30일 지났는지 확인해주는 함수
    /// - Returns: Bool 값
    /// @discussion
    /// - 1월 1일 -> 1월 31일 true
    /// - 1월 2일 -> 1월 31일 false, 2월 1일 true

    // swiftlint: disable force_unwrapping
    func isPassed30Days() -> Bool {
        // 날짜에 맞추기 위해 뒤에 시간을 잘라줘야됨 2023-01-01-23:00:00 -> 2023-01-01
        // 시간이 남아있으면 1월 1일 오후 11시에 업데이트를 하면 1월 30일 오후 11시부터 업데이트가 가능함
        // formatter를 통해 시간을 짤라 날짜로만 계산함
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: self)
        let targetDate = formatter.date(from: stringDate)!

        let after30Days = Calendar.current.date(byAdding: .day, value: 30, to: targetDate)!
        let now = Date()

        // after30Days < now
        return after30Days.compare(now) == .orderedAscending ? true : false
    }

    func after30Days() -> Date {
        return Calendar.current.date(byAdding: .day, value: +30, to: self)!
    }
}
