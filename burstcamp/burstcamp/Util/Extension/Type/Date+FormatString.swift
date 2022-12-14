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
}
