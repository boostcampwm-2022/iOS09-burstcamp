//
//  DateFormatter.swift
//  burstcamp
//
//  Created by youtak on 2022/11/23.
//

import Foundation

extension Date {

    // MARK: - Properties
    var monthDateFormatString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter.string(from: self)
    }

    var yearMonthDateFormatString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"

        return formatter.string(from: self)
    }
}

//
