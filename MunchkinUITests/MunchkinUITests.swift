//
//  MunchkinUITests.swift
//  MunchkinUITests
//
//  Created by Neifmetus on 15.02.2022.
//

import XCTest

class MunchkinUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        print("Test")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        print("")
        
        let plusButtonCount = app.buttons.labelContains(text: "+").count
        print("\(plusButtonCount)")
        
        let plusButtonIdCount = app.buttons.identifierContains(text: "+").count
        print("\(plusButtonIdCount)")
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
