//
//  UserDataProvider.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

protocol UserDataProviderDelegate {
    func didUpdate(user: User)
}

protocol UserDataProviderProtocol {
    var delegate: UserDataProviderDelegate? { get set }
    func fetchUsers(offset: Int,
                    completionHandler: @escaping (Result<[User], NetworkError>) -> Void)
    func fetchUserDetail(login: String,
                   completionHandler: @escaping (Result<User, NetworkError>) -> Void)
    func save(user: User) -> Bool
}

struct UserDataProvider: UserDataProviderProtocol {
    var delegate: UserDataProviderDelegate?
    let userPersistenceStore: UserPersistenceStoreProtocol
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.sharedInstance,
         userPersistenceStore: UserPersistenceStoreProtocol = UserPersistenceStore()) {
        self.networkManager = networkManager
        self.userPersistenceStore = userPersistenceStore
    }
    
    func fetchUsers(offset: Int,
                    completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        let users = userPersistenceStore.fetchUsers(offset: offset)
        if !users.isEmpty {
            completionHandler(.success(users))
            importLatestUserData(offset: offset)
            return
        }
        
        networkManager.process(networkHandler: UserListNetworkHandler(offset: offset)) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
                userPersistenceStore.saveUsers(users: response) { _ in}
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func importLatestUserData(offset: Int) {
        networkManager.process(networkHandler: UserListNetworkHandler(offset: offset)) { result in
            switch result {
            case .success(let response):
                userPersistenceStore.saveUsers(users: response) { _ in}
            case .failure(_):
                //TODO:// Need to define for retry as not clear in requirement
                debugPrint("Failed to import data")
            }
        }
    }
    
    func fetchUserDetail(login: String,
                   completionHandler: @escaping (Result<User, NetworkError>) -> Void) {
        networkManager.process(networkHandler: UserNetworkHandler(login:  login)) { result in
            switch result {
            case .success(var response):
                response.isSeen = true
                let updatedUser = userPersistenceStore.updateDetail(user: response)
                completionHandler(.success(updatedUser))
                delegate?.didUpdate(user: updatedUser)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func save(user: User) -> Bool {
        let result = userPersistenceStore.saveDetail(user: user)
        delegate?.didUpdate(user: user)
        return result
    }
}
