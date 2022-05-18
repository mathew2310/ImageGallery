//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Mathew Ijidakinro on 16/05/2022.
//

import XCTest
import Combine
@testable import ImageGallery

class ImageGalleryTests: XCTestCase {
    
    var viewModel:ImageSearchGalleryViewModel!
    var networkManager:MockNetworkManager!
    private var bindings = Set<AnyCancellable>()

    override func setUpWithError() throws {
        
        networkManager = MockNetworkManager()
        
        viewModel = ImageSearchGalleryViewModel(networkManager: networkManager)
    }


    override func tearDownWithError() throws {
        viewModel = nil
    
    }

    func testSearchPhotos_success() {

        viewModel.search(keyword: "SearchResponse")
        
        XCTAssertEqual(viewModel.imageRecords.count, 20)
        

        XCTAssertNotNil(        viewModel.cachedRecords["searchresponse"]
)
    }
    
    func testSearchPhotos_failure() {

        viewModel.search(keyword: "FailureResponse")


        XCTAssertEqual(viewModel.imageRecords.count, 0)

        XCTAssertNil(        viewModel.cachedRecords["failureresponse"])
    }
    
}
