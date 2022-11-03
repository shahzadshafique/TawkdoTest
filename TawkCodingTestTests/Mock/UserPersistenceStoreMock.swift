//
//  UserPersistenceStoreMock.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

@testable import TawkCodingTest

final class UserPersistenceStoreMock: UserPersistenceStoreProtocol {
    var saveUsersCalled = false
    var saveDetailCalled = false
    var updateDetailCalled = false
    var fetchUsersCalled = false
    var fetchUserCalled = false
    
    var usersToReturn = [User]()
    
    func saveUsers(users: [TawkCodingTest.User], completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        saveUsersCalled = true
    }
    
    func saveDetail(user: User) -> Bool {
        saveDetailCalled = true
       return true
    }
    
    func updateDetail(user: User) -> User {
        updateDetailCalled = true
        return user
    }
    
    func fetchUsers(offset: Int) -> [User] {
        fetchUsersCalled = true
        return usersToReturn
    }
    
    func fetchUser(login: String) -> User? {
        fetchUserCalled = true
        return nil
    }
    
    func reset() {
        saveUsersCalled = false
        saveDetailCalled = false
        updateDetailCalled = false
        fetchUsersCalled = false
        fetchUserCalled = false
        usersToReturn.removeAll()
    }
}
