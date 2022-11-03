//
//  ImageNetworkHandlerTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class ImageNetworkHandlerTests: XCTestCase {
    
    func testImageNetworkHandler() throws {
        let expectedURL = "https://avatars.githubusercontent.com"
        let userNetworkHandler = ImageNetworkHandler(url: expectedURL)
        
        let request = try XCTUnwrap(userNetworkHandler.makeRequest())
        let url = try XCTUnwrap(request.url)
        
        XCTAssertEqual(url, URL(string: expectedURL)!)
    }
}
