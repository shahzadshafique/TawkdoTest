//
//  ImageProviderTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

import XCTest
@testable import TawkCodingTest

final class ImageProviderTests: XCTestCase {
    private let urlProtocolMock = URLProtocolMock()
    private let cacheMock = URLCacheMock()
    private var urlSession: URLSession!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession.init(configuration: configuration)
    }
    
    override func tearDown() {
        URLProtocolMock.networkRequestHappened = false
        cacheMock.reset()
    }
    
    func testFetchImage_WithoutAlreadySavedImage() throws {
        let imageFetchExpectation = XCTestExpectation(description: "Fetch Image")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, SampleData.sampleImageData())
          }
        let imageProvider = ImageProvider(urlSession: urlSession, cache: cacheMock)
        var retrivedImage: UIImage?
        imageProvider.fetchImage(url: "www.test.com") { result in
            switch result {
            case .success(let image):
                retrivedImage = image
            default:break
            }
            imageFetchExpectation.fulfill()
        }
        
        wait(for: [imageFetchExpectation], timeout: 2.0)
        
        XCTAssertNotNil(retrivedImage)
        XCTAssertTrue(URLProtocolMock.networkRequestHappened)
        XCTAssertTrue(cacheMock.storeCacheCalled)
    }
    
    func testFetchImage_WithSavedImage() throws {
        cacheMock.dataToReturn = SampleData.sampleImageData()
        let imageFetchExpectation = XCTestExpectation(description: "Fetch Image")
        let imageProvider = ImageProvider(urlSession: urlSession, cache: cacheMock)
        var retrivedImage: UIImage?
        imageProvider.fetchImage(url: "www.test.com") { result in
            switch result {
            case .success(let image):
                retrivedImage = image
            default:break
            }
            imageFetchExpectation.fulfill()
        }
        
        wait(for: [imageFetchExpectation], timeout: 2.0)
        
        XCTAssertNotNil(retrivedImage)
        XCTAssertFalse(URLProtocolMock.networkRequestHappened)
    }
    
}
