//
//  StringsTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class StringsTests: XCTestCase {
    func testStrings() {
        XCTAssertEqual(String(string: .save), "Save")
        XCTAssertEqual(String(string: .users), "Users")
        XCTAssertEqual(String(string: .note), "Notes")
        XCTAssertEqual(String(string: .email), "Email")
        XCTAssertEqual(String(string: .blog), "Blog")
        XCTAssertEqual(String(string: .email), "Email")
        XCTAssertEqual(String(string: .location), "Location")
        XCTAssertEqual(String(string: .company), "Company")
        XCTAssertEqual(String(string: .name), "Name")
        XCTAssertEqual(String(string: .followers), "Followers")
        XCTAssertEqual(String(string: .following), "Following")
        XCTAssertEqual(String(string: .saveErrorMessage), "There was an error while saving, please try again later")
        XCTAssertEqual(String(string: .saveSuccessMessage), "saved successfully")
        XCTAssertEqual(String(string: .generalErrorMessage), "Something went wrong, please try again later.")
        XCTAssertEqual(String(string: .networkErrorMessage), "You are currently offline")
        XCTAssertEqual(String(string: .viewDetail), "Detail")
        XCTAssertEqual(String(string: .errorTitle), "Error!")
        XCTAssertEqual(String(string: .okButtonTitle), "OK")
        XCTAssertEqual(String(string: .retryButtonTitle), "Retry")
        
    }
}
