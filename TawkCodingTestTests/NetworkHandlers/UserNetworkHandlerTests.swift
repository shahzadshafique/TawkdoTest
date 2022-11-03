//
//  UserNetworkHandlerTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class UserNetworkHandlerTests: XCTestCase {
    
    func testNetworkHandler() throws {
        let userNetworkHandler = UserNetworkHandler(login: "123")
        let expectedURL = Environment.development.baseURL + EndPoint.Users.rawValue + "/123"
        let request = try XCTUnwrap(userNetworkHandler.makeRequest())
        let url = try XCTUnwrap(request.url)
        
        XCTAssertEqual(url, URL(string: expectedURL)!)
        
        let user = try userNetworkHandler.parseResponse(data: SampleData.createUserData(), response: HTTPURLResponse(), request: request)
        XCTAssertEqual(user.login, "mojombo")
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Tom Preston-Werner")
        XCTAssertEqual(user.followers, 23228)
    }
}
