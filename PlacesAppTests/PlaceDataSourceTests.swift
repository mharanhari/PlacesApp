//
//  PlaceDataSourceTests.swift
//  PlacesAppTests
//
//  Created by Hariharan on 01/10/20.
//  Copyright © 2020 Hariharan. All rights reserved.
//

import XCTest
@testable import PlacesApp

class PlaceDataSourceTests: XCTestCase {

     var dataSource: PlaceDataSource!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataSource = PlaceDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataSource = nil
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
    
    func testEmptyValueInDataSource() {
        
        // giving empty data value
        dataSource.data.value = []
        
        let tableView = UITableView()
        tableView.dataSource = dataSource
        
        // expected zero cells
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 0, "Expected no cell in table view")
    }
    
    func testValueInDataSource() {
        
        // giving data value
        let place1 = PlaceInfo(title: "Beavers", description: nil, imageHref: nil)
        let place2 = PlaceInfo(title: "Flag", description: nil, imageHref: nil)
        dataSource.data.value = [place1, place2]
        
        let tableView = UITableView()
        tableView.dataSource = dataSource
                
        // expected two cells
        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 2, "Expected two cell in table view")
    }
    
    func testValueCell() {
        // giving data value
        let place1 = PlaceInfo(title: "Beavers", description: "Beavers are second only to humans", imageHref: "")
        dataSource.data.value = [place1]
        
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "placeCell")
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? PlaceTableViewCell
        
        //expected PlaceTableViewCell class
        XCTAssertNotNil(cell)
    }

}
