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
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 30초 전
    /// 출력 : 방금 전
    func test_시간포매팅_30초() throws {
        let beforeTime = TimeInterval.before(seconds: 30)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 40초 전
    /// 출력 : 방금 전
    func test_시간포매팅_40초() throws {
        let beforeTime = TimeInterval.before(seconds: 40)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    /// pubDate : 1분 40초 전
    /// 출력 : 1분 전
    func test_시간포매팅__1분전() throws {
        let beforeTime = TimeInterval.before(seconds: 40, minutes: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "1분 전")
    }

    /// pubDate : 32분 32초 전
    /// 출력 : 32분 전
    func test_시간포매팅_분전_02() throws {
        let beforeTime = TimeInterval.before(seconds: 32, minutes: 32)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "32분 전")
    }

    /// pubDate : 59분 59초전
    /// 출력 : 59분 전
    func test_시간포매팅_분전_03() throws {
        let beforeTime = TimeInterval.before(seconds: 59, minutes: 59)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "59분 전")
    }

    /// pubDate : 1시간 39분 42초전
    /// 출력 : 1시간 전
    func test_시간포매팅_시간전_01() throws {
        let beforeTime = TimeInterval.before(seconds: 42, minutes: 39, hours: 1)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "1시간 전")
    }

    /// pubDate : 12시간 25분 01초전
    /// 출력 : 12시간 전
    func test_시간포매팅_시간전_02() throws {
        let beforeTime = TimeInterval.before(seconds: 01, minutes: 25, hours: 12)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "12시간 전")
    }

    /// pubDate : 23시간 59분 59초전
    /// 출력 : 23시간 전
    func test_시간포매팅_시간전_03() throws {
        let beforeTime = TimeInterval.before(seconds: 59, minutes: 59, hours: 23)
        let pubDate = Date(timeIntervalSinceNow: beforeTime)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "23시간 전")
    }

    func test_시간포매팅_일전_01() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "4일 전")
    }

    func test_시간포매팅_일전_02() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "1일 전")
    }

    func test_시간포매팅_일전_03() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "6일 전")
    }

    func test_시간포매팅_특정날짜_01() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "10월 29일")
    }

    func test_시간포매팅_특정날짜_02() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "11월 04일")
    }

    func test_시간포매팅_특정날짜_03() throws {
        let pubDate = Date(timeIntervalSinceNow: -86400)
        let result = Date.relativeTime(pubDate: pubDate)
        XCTAssertEqual(result, "11월 16일")
    }
}
