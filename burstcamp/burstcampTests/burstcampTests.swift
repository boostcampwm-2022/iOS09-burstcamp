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

    func test_시간포매팅_방금전_01() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    func test_시간포매팅_방금전_02() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }

    func test_시간포매팅_방금전_03() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "방금 전")
    }
    func test_시간포매팅_분전_01() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "1분 전")
    }

    func test_시간포매팅_분전_02() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "32분 전")
    }

    func test_시간포매팅_분전_03() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "59분 전")
    }

    func test_시간포매팅_시간전_01() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "1시간 전")
    }

    func test_시간포매팅_시간전_02() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "12시간 전")
    }

    func test_시간포매팅_시간전_03() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "23시간 전")
    }

    func test_시간포매팅_일전_01() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "4일 전")
    }

    func test_시간포매팅_일전_02() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "1일 전")
    }

    func test_시간포매팅_일전_03() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "6일 전")
    }

    func test_시간포매팅_특정날짜_01() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "10월 29일")
    }

    func test_시간포매팅_특정날짜_02() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "11월 04일")
    }

    func test_시간포매팅_특정날짜_03() throws {
        let today = Date()
        let one_day_before = Date(timeIntervalSinceNow: -86400)
        let pubDate = one_day_before
        let result = DateFormatter.time(pubDate: pubDate)
        XCTAssertEqual(result, "11월 16일")
    }
}
