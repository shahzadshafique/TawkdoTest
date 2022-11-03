//
//  URLCacheMock.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

@testable import TawkCodingTest
import UIKit

final class URLCacheMock: URLCacheProtocol {
    
    var dataToReturn: Data?
    var storeCacheCalled = false
    
    func reset() {
        dataToReturn = nil
        storeCacheCalled = false
    }
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        storeCacheCalled = true
    }
    
    func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        guard let dataToReturn = dataToReturn else { return nil }
        return CachedURLResponse(response: URLResponse(), data: dataToReturn)
    }
}
