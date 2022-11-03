//
//  UserNetworkHandler.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

struct UserNetworkHandler: NetworkHandler {
    
    typealias Response = User
    private let login: String
    
    init(login: String) {
        self.login = login
    }
    
    func makeRequest() -> URLRequest? {
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 40)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func parseResponse(data: Data,
                       response: HTTPURLResponse,
                       request: URLRequest) throws -> User {
        let decoder = JSONDecoder()
        return try decoder.decode(User.self, from: data)
    }
}

extension UserNetworkHandler {
    
    private var url: URL? {
        // TODO: This can be injected using dependency injection for whole app
        let path = Environment.development.baseURL + EndPoint.Users.rawValue + "/\(login)"
        guard let urlComponent = URLComponents(string: path) else {
            return nil
        }
        
        return urlComponent.url
    }
}
