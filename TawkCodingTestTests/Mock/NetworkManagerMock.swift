//
//  NetworkManagerMock.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 01/11/2022.
//

@testable import TawkCodingTest
import Foundation

final class NetworkManagerMock: NetworkManagerProtocol {
    
    var networkError: NetworkError?
    var responseData = SampleData.createUserListData()
    
    func process<Handler: NetworkHandler>(networkHandler: Handler,
                                          completionHandler: @escaping ((Result<Handler.Response, NetworkError>) -> Void)) {
        guard let request = networkHandler.makeRequest() else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        if let networkError = networkError {
            completionHandler(.failure(networkError))
        } else {
            do {
                try completionHandler(.success(networkHandler.parseResponse(data: responseData, response: HTTPURLResponse(), request: request)))
            } catch {
                completionHandler(.failure(.parsingError))
            }
        }
    }
    
    func reset() {
        networkError = nil
    }
}
