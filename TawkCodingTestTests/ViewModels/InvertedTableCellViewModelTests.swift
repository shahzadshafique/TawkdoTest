//
//  InvertedTableCellViewModelTests.swift
//  TawkCodingTestTests
//
//  Created by shahzadshafique on 02/11/2022.
//

import XCTest
import UIKit
@testable import TawkCodingTest

final class InvertedTableCellViewModelTests: XCTestCase {
    let imageProvider = ImageProviderMock()
    
    override func setUp() {
        imageProvider.reset()
    }
    
    func testInvertedTableCellViewModel() throws {
        imageProvider.imageToReturn = UIImage(systemName: "person.circle")
        let dataModel = UserTableCellDataModel(title: "test", subTitle: "test subtitle", imageURL: "www.test.com", showAsSeen: true)
        var viewModel = InvertedTableCellViewModel(userDataModel: dataModel, imageProvider: imageProvider)
        XCTAssertEqual(viewModel.imageURL, "www.test.com")
        XCTAssertEqual(viewModel.title, "test")
        XCTAssertEqual(viewModel.subTitle, "test subtitle")
        XCTAssertTrue(viewModel.showAsSeen)
        
        let imageFetchExpectation = XCTestExpectation(description: "Fetch Image")
        var imageReceived: UIImage?
        viewModel.updateImage = { result in
            switch result {
            case .success(let image):
                imageReceived = image
            default: break
            }
            imageFetchExpectation.fulfill()
        }
        viewModel.loadImage()
        wait(for: [imageFetchExpectation], timeout: 2.0)
        XCTAssertNotNil(imageReceived)
    }
    
    func testInvertedTableCellViewModel_ForWrongDataModel() throws {
        imageProvider.error = .invalidRequest
        let dataModel = FakeDataModel()
        var viewModel = InvertedTableCellViewModel(userDataModel: dataModel, imageProvider: imageProvider)
        XCTAssertTrue(viewModel.imageURL.isEmpty)
        XCTAssertTrue(viewModel.title.isEmpty)
        XCTAssertTrue(viewModel.subTitle.isEmpty)
        XCTAssertFalse(viewModel.showAsSeen)
        
        let imageFetchExpectation = XCTestExpectation(description: "Fetch Image")
        var errorReceived: Error?
        viewModel.updateImage = { result in
            switch result {
            case .failure(let error):
                errorReceived = error
            default: break
            }
            imageFetchExpectation.fulfill()
        }
        viewModel.loadImage()
        wait(for: [imageFetchExpectation], timeout: 2.0)
        XCTAssertNotNil(errorReceived)
    }
    
}
