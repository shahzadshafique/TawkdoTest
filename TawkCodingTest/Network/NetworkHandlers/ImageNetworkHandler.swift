//
//  ImageNetworkHandler.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

struct ImageNetworkHandler: NetworkHandler {
    
    typealias Response = Data
    private let imageURL: String
    
    init(url: String) {
        self.imageURL = url
    }
    
    func makeRequest() -> URLRequest? {
        guard let url = URLComponents(string: imageURL)?.url else {
            return nil
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 40)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}
