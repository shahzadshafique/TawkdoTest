//
//  NetworkManager.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case parsingError
    case noData
    case connectionError
    case other(Error)
    
    
}

extension Error {
    var title: String {
        String(string: .errorTitle)
    }
    
    var message: String {
        guard let networkError = self as? NetworkError else {
            return String(string: .generalErrorMessage)
        }
        
        switch networkError {
        case .connectionError:
            return String(string: .networkErrorMessage)
        default:
            return String(string: .generalErrorMessage)
        }
    }

}

protocol NetworkManagerProtocol {
    func process<Handler: NetworkHandler>(networkHandler: Handler,
                                          completionHandler: @escaping ((Result<Handler.Response, NetworkError>) -> Void))
}

final class NetworkManager: NetworkManagerProtocol {
    
    private lazy var queue: DispatchQueue = {
        let queue = DispatchQueue(label: "tawkdo.serial.queue", qos: .background)
        return queue;
    }()
    
    static let sharedInstance = NetworkManager()
    // As per requirement we need to process one network request at a time.
    private let semaphore = DispatchSemaphore(value: 1)
    
    func process<Handler: NetworkHandler>(networkHandler: Handler,
                                          completionHandler: @escaping ((Result<Handler.Response, NetworkError>) -> Void))  {
        
        queue.async { [weak self] in
            guard let self = self else { return }
            self.semaphore.wait()
            guard let urlRequest = networkHandler.makeRequest() else {
                completionHandler(.failure(.invalidRequest))
                self.semaphore.signal()
                return
            }
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    completionHandler(.failure(.other(error)))
                    self.semaphore.signal()
                    return
                }
                //TODO: Error management call be handled separately
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    completionHandler(.failure(.invalidRequest))
                    self.semaphore.signal()
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(.noData))
                    self.semaphore.signal()
                    return
                }
                
                do {
                    try completionHandler(.success(networkHandler.parseResponse(data: data, response: response, request: urlRequest)))
                } catch {
                    completionHandler(.failure(.parsingError))
                }
                self.semaphore.signal()
            }
            .resume()
        }
    }
    
    
}
