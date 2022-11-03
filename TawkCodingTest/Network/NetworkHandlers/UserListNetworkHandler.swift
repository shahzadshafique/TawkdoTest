//
//  UserListNetworkHandler.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

struct UserListNetworkHandler: NetworkHandler {
    
    typealias Response = [User]
    private let offset: Int
    
    private enum ParamKey {
        static let offset = "since"
    }
    
    init(offset: Int = 0) {
        self.offset = offset
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
                       request: URLRequest) throws -> [User] {
        let decoder = JSONDecoder()
        return try decoder.decode([User].self, from: data)
    }
}

extension UserListNetworkHandler {
    private var queryItems: [URLQueryItem] {
        [URLQueryItem(name: ParamKey.offset, value: String(offset))]
    }
    
    private var url: URL? {
        // TODO: This can be injected using dependency injection for whole app
        let path = Environment.development.baseURL + EndPoint.Users.rawValue
        guard var urlComponent = URLComponents(string: path) else {
            return nil
        }
        
        urlComponent.queryItems = queryItems
        return urlComponent.url
    }
}
