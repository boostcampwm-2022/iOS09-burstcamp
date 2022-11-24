//
//  burstcampTests.swift
//  burstcampTests
//
//  Created by youtak on 2022/11/23.
//

import XCTest

@testable import burstcamp

final class burstcampTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// pubDate : 1초전
    /// 출력 : 방금 전
    func test_시간포매팅_1초() throws {
        let beforeTime = TimeInterval.before(seconds: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 30초 전
    /// 출력 : 방금 전
    func test_시간포매팅_30초() throws {
        let beforeTime = TimeInterval.before(seconds: 30)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 40초 전
    /// 출력 : 방금 전
    func test_시간포매팅_40초() throws {
        let beforeTime = TimeInterval.before(seconds: 40)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 59초 전
    /// 출력 : 방금 전
    func test_시간포매팅_59초() throws {
        let beforeTime = TimeInterval.before(seconds: 59)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 1분 40초 전
    /// 출력 : 1분 전
    func test_시간포매팅_1분전() throws {
        let beforeTime = TimeInterval.before(seconds: 40, minutes: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "1분 전")
    }

    /// pubDate : 32분 32초 전
    /// 출력 : 32분 전
    func test_시간포매팅_32분전() throws {
        let beforeTime = TimeInterval.before(seconds: 32, minutes: 32)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "32분 전")
    }

    /// pubDate : 59분 59초전
    /// 출력 : 59분 전
    func test_시간포매팅_59분전() throws {
        let beforeTime = TimeInterval.before(seconds: 59, minutes: 59)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "59분 전")
    }

    /// pubDate : 1시간 39분 42초전
    /// 출력 : 1시간 전
    func test_시간포매팅_1시간전() throws {
        let beforeTime = TimeInterval.before(seconds: 42, minutes: 39, hours: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "1시간 전")
    }

    /// pubDate : 12시간 25분 01초전
    /// 출력 : 12시간 전
    func test_시간포매팅_12시간전() throws {
        let beforeTime = TimeInterval.before(seconds: 01, minutes: 25, hours: 12)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "12시간 전")
    }

    /// pubDate : 23시간 59분 59초전
    /// 출력 : 23시간 전
    func test_시간포매팅_23시간전() throws {
        let beforeTime = TimeInterval.before(seconds: 59, minutes: 59, hours: 23)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "23시간 전")
    }

    /// pubDate : 4일 12시간 40분 40초전
    /// 출력 : 4일전
    func test_시간포매팅_4일전() throws {
        let beforeTime = TimeInterval.before(seconds: 40, minutes: 40, hours: 12, days: 4)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "4일 전")
    }

    /// pubDate : 1일 0시간 0분 0초전
    /// 출력 : 1일전
    func test_시간포매팅_1일전() throws {
        let beforeTime = TimeInterval.before(seconds: 0, minutes: 0, hours: 0, days: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "1일 전")
    }

    /// pubDate : 6일 23시간 59분 59초전
    /// 출력 : 6일전
    func test_시간포매팅_6일전() throws {
        let beforeTime = TimeInterval.before(seconds: 59, minutes: 59, hours: 23, days: 6)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = BCDateFormatter.relativeTimeString(for: pubDate)
        XCTAssertEqual(result, "6일 전")
    }

    /// specific : 2022년 11월 23일 12시
    /// pubdate : 2022년 10월 25일 5시
    /// 출력 : 10월 25일
    func test_시간포매팅_10월25일() throws {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(year: 2022, month: 10, day: 25, hour: 5)
        let targetDate = calendar.date(from: targetDateComponents)
        let pubDate = try XCTUnwrap(targetDate)

        let standardDateComponents = DateComponents(year: 2022, month: 11, day: 23, hour: 12)
        let standardDate = calendar.date(from: standardDateComponents)
        let specificDate = try XCTUnwrap(standardDate)

        let result = BCDateFormatter.relativeTimeString(for: pubDate, relativeTo: specificDate)
        XCTAssertEqual(result, "10월 25일")
    }

    /// specific : 2022년 11월 23일 12시
    /// pubDate : 2022년 5월 4일 13시
    /// 출력 : 5월 4일
    func test_시간포매팅_5월4일() throws {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(year: 2022, month: 5, day: 4, hour: 13)
        let targetDate = calendar.date(from: targetDateComponents)
        let pubDate = try XCTUnwrap(targetDate)

        let standardDateComponents = DateComponents(year: 2022, month: 11, day: 23, hour: 12)
        let standardDate = calendar.date(from: standardDateComponents)
        let specificDate = try XCTUnwrap(standardDate)

        let result = BCDateFormatter.relativeTimeString(for: pubDate, relativeTo: specificDate)
        XCTAssertEqual(result, "5월 4일")
    }

    /// specific : 2022년 11월 23일 12시
    /// pubDate : 2022년 7월 18일 10시
    /// 출력 : 7월 18일
    func test_시간포매팅_7월18일() throws {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(year: 2022, month: 7, day: 18, hour: 10)
        let targetDate = calendar.date(from: targetDateComponents)
        let pubDate = try XCTUnwrap(targetDate)

        let standardDateComponents = DateComponents(year: 2022, month: 11, day: 23, hour: 12)
        let standardDate = calendar.date(from: standardDateComponents)
        let specificDate = try XCTUnwrap(standardDate)

        let result = BCDateFormatter.relativeTimeString(for: pubDate, relativeTo: specificDate)
        XCTAssertEqual(result, "7월 18일")
    }

    /// specific : 2022년 11월 23일 12시
    /// pubDate :  2021년10월 25일 5시
    /// 출력 : 21.10.25
    func test_시간포매팅_1년지난_10월25일() throws {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(year: 2021, month: 10, day: 25, hour: 5)
        let targetDate = calendar.date(from: targetDateComponents)
        let pubDate = try XCTUnwrap(targetDate)

        let standardDateComponents = DateComponents(year: 2022, month: 11, day: 23, hour: 12)
        let standardDate = calendar.date(from: standardDateComponents)
        let specificDate = try XCTUnwrap(standardDate)

        let result = BCDateFormatter.relativeTimeString(for: pubDate, relativeTo: specificDate)
        XCTAssertEqual(result, "21.10.25")
    }

    /// specific : 2022년 11월 23일 12시
    /// pubDate :  2021년 5월 5일 5시 5분 5초
    /// 출력 : 21.05.05
    func test_시간포매팅_1년지난_5월5일() throws {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(
            year: 2021,
            month: 5,
            day: 5,
            hour: 5,
            minute: 5,
            second: 5
        )
        let targetDate = calendar.date(from: targetDateComponents)
        let pubDate = try XCTUnwrap(targetDate)

        let standardDateComponents = DateComponents(year: 2022, month: 11, day: 23, hour: 12)
        let standardDate = calendar.date(from: standardDateComponents)
        let specificDate = try XCTUnwrap(standardDate)

        let result = BCDateFormatter.relativeTimeString(for: pubDate, relativeTo: specificDate)
        XCTAssertEqual(result, "21.05.05")
    }
}
