//
//  UserDataProvderTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class UserDataProvderTests: XCTestCase {
    private let userPersistenceStore = UserPersistenceStoreMock()
    private let networkManager = NetworkManagerMock()
    private var userDataProvider: UserDataProvider!
    private var userDelegateCalled = false
    
    override func setUp() {
        userDataProvider = UserDataProvider(networkManager: networkManager,
                                            userPersistenceStore: userPersistenceStore)
        userDataProvider.delegate = self
    }
    
    override func tearDown() {
        userPersistenceStore.reset()
        networkManager.reset()
        userDelegateCalled = false
    }
    
    func testFetchUser_WithAlreadySavedData() {
        let userFetchExpectation = XCTestExpectation(description: "Fetch Users")
        let expectedUsers = SampleData.createUserListArray()
        userPersistenceStore.usersToReturn = expectedUsers
        var fetchedUsers: [User] = []
        userDataProvider.fetchUsers(offset: 0) { result in
            switch result {
            case .success(let users):
                fetchedUsers = users
            case .failure(_): break
            }
            userFetchExpectation.fulfill()
        }
        
        wait(for: [userFetchExpectation], timeout: 2.0)
        
        XCTAssertFalse(fetchedUsers.isEmpty)
        XCTAssertTrue(userPersistenceStore.fetchUsersCalled)
        XCTAssertEqual(fetchedUsers.count, expectedUsers.count)
    }
    
    func testFetchUser_FromNetwork() {
        let userFetchExpectation = XCTestExpectation(description: "Fetch Users")
        networkManager.responseData = SampleData.createUserListData()
        var fetchedUsers: [User] = []
        userDataProvider.fetchUsers(offset: 0) { result in
            switch result {
            case .success(let users):
                fetchedUsers = users
            case .failure(_): break
            }
            userFetchExpectation.fulfill()
        }
        
        wait(for: [userFetchExpectation], timeout: 2.0)
        
        XCTAssertFalse(fetchedUsers.isEmpty)
        XCTAssertTrue(userPersistenceStore.saveUsersCalled)
        XCTAssertEqual(fetchedUsers.count, 3)
    }
    
    func testFetchUser_WithError() {
        let userFetchExpectation = XCTestExpectation(description: "Fetch Users")
        networkManager.networkError = .noData
        
        var errorReceived: NetworkError?
        userDataProvider.fetchUsers(offset: 0) { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                errorReceived = error
            }
            userFetchExpectation.fulfill()
        }
        
        wait(for: [userFetchExpectation], timeout: 2.0)
        
        XCTAssertNotNil(errorReceived)
    }
    
    func testFetchUserDetail_Success() {
        let userDetailExpectation = XCTestExpectation(description: "Fetch Detail")
        networkManager.responseData = SampleData.createUserData()
        var fetchedUser: User?
        userDataProvider.fetchUserDetail(login: "123") { result in
            switch result {
            case .success(let user):
                fetchedUser = user
            default: break
            }
            
            userDetailExpectation.fulfill()
        }
        
        wait(for: [userDetailExpectation], timeout: 2.0)
        
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser!.name, "Tom Preston-Werner")
        XCTAssertTrue(fetchedUser!.isSeen)
        XCTAssertTrue(userPersistenceStore.updateDetailCalled)
        XCTAssertTrue(userDelegateCalled)
    }
    
    func testFetchUserDetail_Failure() {
        let userDetailExpectation = XCTestExpectation(description: "Fetch Detail")
        networkManager.networkError = .noData
        var errorReceived: NetworkError?
        userDataProvider.fetchUserDetail(login: "123") { result in
            switch result {
            case .failure(let error):
                errorReceived = error
            default: break
            }
            
            userDetailExpectation.fulfill()
        }
        
        wait(for: [userDetailExpectation], timeout: 2.0)
        
        XCTAssertNotNil(errorReceived)
        XCTAssertFalse(userPersistenceStore.updateDetailCalled)
        XCTAssertFalse(userDelegateCalled)
    }
    
    func testSaveUser() {
        XCTAssertTrue(userDataProvider.save(user: SampleData.createUserListArray().first!))
        XCTAssertTrue(userPersistenceStore.saveDetailCalled)
        XCTAssertTrue(userDelegateCalled)
    }

}

extension UserDataProvderTests: UserDataProviderDelegate {
    func didUpdate(user: User) {
        userDelegateCalled = true
    }
}
