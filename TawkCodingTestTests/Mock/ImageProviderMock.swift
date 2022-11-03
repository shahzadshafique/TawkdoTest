//
//  ImageProviderMock.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

@testable import TawkCodingTest
import UIKit

final class ImageProviderMock: ImageProviderProtocol {
    var error: NetworkError?
    var imageToReturn: UIImage?
    func fetchImage(url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(imageToReturn))
        }
    }
    
    func reset() {
        error = nil
        imageToReturn = nil
    }
}
