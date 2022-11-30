//
//  ValidationTest.swift
//  burstcampTests
//
//  Created by neuli on 2022/11/29.
//

import XCTest
@testable import burstcamp

final class ValidationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_tistoryLink_validate_success() throws {
        let tistoryLink1 = #"https://luen.tistory.com"#
        let tistoryLink2 = #"https://ios-development.tistory.com"#
        let result1 = Validation.validateRegexp(blogLink: tistoryLink1)
        let result2 = Validation.validateRegexp(blogLink: tistoryLink2)
        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, true)
    }

    func test_tistoryLink_validate_fail() throws {
        let tistoryLink1 = #"https://lue_n.tistory.com"#
        let tistoryLink2 = #"https://ios-development.tistory.com/hello"#
        let result1 = Validation.validateRegexp(blogLink: tistoryLink1)
        let result2 = Validation.validateRegexp(blogLink: tistoryLink2)
        XCTAssertEqual(result1, false)
        XCTAssertEqual(result2, false)
    }

    func test_velogLink_validate_success() throws {
        let velogLink1 = #"https://velog.io/@wijoonwu"#
        let velogLink2 = #"https://velog.io/@ninto_2"#
        let result1 = Validation.validateRegexp(blogLink: velogLink1)
        let result2 = Validation.validateRegexp(blogLink: velogLink2)
        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, true)
    }

    func test_velogLink_validate_fail() throws {
        let velogLink1 = #"https://velog.io/@wijoonwu/22년-4분기-회고-첫-취업-후기feat.스타트업"#
        let velogLink2 = #"https://velog.io/@ninto_2/커밋-컨벤션"#
        let result1 = Validation.validateRegexp(blogLink: velogLink1)
        let result2 = Validation.validateRegexp(blogLink: velogLink2)
        XCTAssertEqual(result1, false)
        XCTAssertEqual(result2, false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
