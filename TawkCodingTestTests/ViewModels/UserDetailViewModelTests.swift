//
//  UserDetailViewModelTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

import XCTest
import Combine
import SwiftUI
@testable import TawkCodingTest

final class UserDetailViewModelTests: XCTestCase {
    private let userDataProvider = UserDataProviderMock()
    private let imageProvider = ImageProviderMock()
    
    override func setUp() {
        userDataProvider.reset()
        imageProvider.reset()
    }

    func testUserDetailViewModel() {
        let user = SampleData.createUserListArray().first!
        userDataProvider.userToReturn = user
        let viewModel = UserDetailViewModel(user: user, userDataProvider: userDataProvider, imageProvider: imageProvider)
        
        XCTAssertEqual(viewModel.state, .idle)
        waitUntil(viewModel.$state, equals: .completed)
        XCTAssertEqual(viewModel.notes, user.note)
        XCTAssertEqual(viewModel.followers, "\(String(string: .followers)): \(user.followers)")
        XCTAssertEqual(viewModel.following, "\(String(string: .following)): \(user.following)")
    }
    
    func testUserDetailViewModel_ForError() {
        let user = SampleData.createUserListArray().first!
        userDataProvider.error = .noData
        let viewModel = UserDetailViewModel(user: user, userDataProvider: userDataProvider, imageProvider: imageProvider)
        
        XCTAssertEqual(viewModel.state, .idle)
        waitUntil(viewModel.$state, equals: .failed)
        XCTAssertEqual(viewModel.notes, "")
        XCTAssertEqual(viewModel.followers, "")
        XCTAssertEqual(viewModel.following, "")
        XCTAssertEqual(viewModel.profileData.count, 0)
    }

}

extension XCTestCase {
    func waitUntil<T: Equatable>(
        _ propertyPublisher: Published<T>.Publisher,
        equals expectedValue: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(
            description: "Awaiting value \(expectedValue)"
        )
        
        var cancellable: AnyCancellable?

        cancellable = propertyPublisher
            .dropFirst()
            .first(where: { $0 == expectedValue })
            .sink { value in
                XCTAssertEqual(value, expectedValue, file: file, line: line)
                cancellable?.cancel()
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)
    }
}
