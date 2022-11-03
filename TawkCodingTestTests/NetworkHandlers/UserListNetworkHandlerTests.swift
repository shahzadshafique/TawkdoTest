//
//  UserListNetworkHandlerTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class UserListNetworkHandlerTests: XCTestCase {

    func testUserListNetworkHandler() throws {
        let userListNetworkHandler = UserListNetworkHandler()
        let expectedURL = Environment.development.baseURL + EndPoint.Users.rawValue + "?since=0"
        let request = try XCTUnwrap(userListNetworkHandler.makeRequest())
        let url = try XCTUnwrap(request.url)
        
        XCTAssertEqual(url, URL(string: expectedURL)!)
        
        let users = try userListNetworkHandler.parseResponse(data: SampleData.createUserListData(), response: HTTPURLResponse(), request: request)
        XCTAssertEqual(users.count, 3)
    }
}
