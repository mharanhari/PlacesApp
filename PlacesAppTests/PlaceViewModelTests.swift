//
//  PlaceViewModelTests.swift
//  PlacesAppTests
//
//  Created by Hariharan on 01/10/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import XCTest
@testable import PlacesApp

class PlaceViewModelTests: XCTestCase {
    var viewModel: PlaceViewModel!
    var dataSource: GenericDataSource<PlaceInfo>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.dataSource = GenericDataSource<PlaceInfo>()
        self.viewModel = PlaceViewModel(dataSource: dataSource)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.dataSource = nil
        self.viewModel = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchPlaces() {
        
        let expectation = XCTestExpectation(description: "Places fetch")
        
        viewModel.onErrorHandling = { _ in
            XCTAssert(false, "ViewModel should not be able to fetch without service")
        }
        
        dataSource.data.addObserver(self) { _ in
            expectation.fulfill()
        }
        
        let completion: ((String) -> Void) = { result in
            XCTAssertNotNil(result)
        }
        
        viewModel.fetchallPlaces(completion: completion)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testParsePlaces() {
        
        // giving a sample json file
        guard let data = FileManager.readJson(forResource: "sample") else {
            XCTAssert(false, "Can't get data from sample.json")
            return
        }
        
        guard let response = viewModel.parseJson(data: data) else {
            XCTAssert(false, "Can't parse data from sample.json")
            return
        }
        
        // expected valid converter with valid data
        XCTAssertEqual(response.rows.first?.title, "Beavers", "Expected Beavers title")
        XCTAssertNotNil(response.rows.first?.imageHref)
        XCTAssertEqual(response.rows.first?.imageHref?.prefix(4), "http", "Image should be a download url")
    }

}
