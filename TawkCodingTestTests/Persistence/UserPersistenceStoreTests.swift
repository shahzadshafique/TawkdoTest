//
//  UserPersistenceStoreTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

import XCTest
@testable import TawkCodingTest
import CoreData

final class UserPersistenceStoreTests: XCTestCase {

    func testSaveDetail() throws {
        let userPersistenceStore = UserPersistenceStore(mainContext: TestCoreDataStack().mainContext, backgroundContext: TestCoreDataStack().backgroundContext)
        let user = SampleData.createUserListArray().first!
        XCTAssertTrue(userPersistenceStore.saveDetail(user: user))
        
        _ = try XCTUnwrap(userPersistenceStore.fetchUser(login: user.login))
    }
    
    func testUpdateUser() throws {
        let userPersistenceStore = UserPersistenceStore(mainContext: TestCoreDataStack().mainContext, backgroundContext: TestCoreDataStack().backgroundContext)
        let user = SampleData.createUserListArray().first!
        XCTAssertTrue(userPersistenceStore.saveDetail(user: user))

        var fetchedUser = try XCTUnwrap(userPersistenceStore.fetchUser(login: user.login))
        XCTAssertFalse(fetchedUser.isSeen)
        XCTAssertNotEqual(fetchedUser.note, "test note")
        fetchedUser.isSeen = true
        fetchedUser.note = "test note"

        let _ = userPersistenceStore.updateDetail(user: fetchedUser)

        let updatedUser = try XCTUnwrap(userPersistenceStore.fetchUser(login: user.login))
        XCTAssertTrue(updatedUser.isSeen)
        XCTAssertEqual(updatedUser.note, "test note")
    }
    
    func testFetchUser() throws {
        let userPersistenceStore = UserPersistenceStore(mainContext: TestCoreDataStack().mainContext, backgroundContext: TestCoreDataStack().backgroundContext)
        let user = SampleData.createUserListArray().first!
        XCTAssertTrue(userPersistenceStore.saveDetail(user: user))
        
        _ = try XCTUnwrap(userPersistenceStore.fetchUser(login: user.login))
        
        XCTAssertNil(userPersistenceStore.fetchUser(login: "343434"))
    }

}
