//
//  UserDataProviderMock.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

@testable import TawkCodingTest

final class UserDataProviderMock: UserDataProviderProtocol {
    
    var fetchUsersMethodCalled = false
    var fetchUserDetailMethodCalled = false
    var saveMethodCalled = false
    
    var delegate: UserDataProviderDelegate?
    
    var userToReturn = SampleData.createUserListArray().first!
    var userListToReturn = SampleData.createUserListArray()
    var error: NetworkError?
    var saveMethodResult = false
    func fetchUsers(offset: Int,
                    completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        fetchUsersMethodCalled = true
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(userListToReturn))
        }
    }
    
    func fetchUserDetail(login: String,
                         completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        fetchUserDetailMethodCalled = true
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(userToReturn))
        }
    }
    
    func save(user: User) -> Bool {
        saveMethodCalled = true
        return saveMethodResult
    }
    
    func reset() {
        fetchUsersMethodCalled = false
        fetchUserDetailMethodCalled = false
        saveMethodCalled = false
        userToReturn = SampleData.createUserListArray().first!
        userListToReturn = SampleData.createUserListArray()
        error = nil
        saveMethodResult = false
    }
}
