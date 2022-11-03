//
//  ImageProvider.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//
import UIKit

protocol ImageProviderProtocol {
    func fetchImage(url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void)
}

protocol URLCacheProtocol {
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
    func cachedResponse(for request: URLRequest) -> CachedURLResponse?
}

extension URLCache: URLCacheProtocol {}

struct ImageProvider: ImageProviderProtocol {
    
    private let cache: URLCacheProtocol
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared,
         cache: URLCacheProtocol = URLCache.shared) {
        self.urlSession = urlSession
        self.cache = cache
    }
    
    func fetchImage(url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        let imageNetworkHandler = ImageNetworkHandler(url: url)
        guard let request = imageNetworkHandler.makeRequest() else { return }
        
        if let image = loadImageFromCache(for: request) {
            completionHandler(.success(image))
        } else {
            urlSession.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    completionHandler(.failure(.other(error)))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    completionHandler(.failure(.invalidRequest))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(.noData))
                    return
                }
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                completionHandler(.success(UIImage(data: data)))
            }
            .resume()
        }
        
    }
    
    private func loadImageFromCache(for request: URLRequest) -> UIImage? {
        guard let data = self.cache.cachedResponse(for: request)?.data,
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
