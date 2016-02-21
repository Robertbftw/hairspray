//
//  HairsprayUITests.swift
//  HairsprayUITests
//
//  Created by Robert Boerema on 2/14/16.
//  Copyright © 2016 Robert Boerema. All rights reserved.
//

import XCTest

class HairsprayUITests: XCTestCase {
        
    override func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        setupSnapshot(app)
        super.setUp()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    snapshot("01LoginScreen")
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        sleep(2)
        snapshot("-Home-")
        app.buttons["Stem Nu"].tap()
        sleep(1)
        snapshot("-Vote-")
        let roundLeftButtonButton = app.buttons["round left button"]
        roundLeftButtonButton.tap()
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.childrenMatchingType(.StaticText).matchingIdentifier("A Change Will Do You Good").elementBoundByIndex(1).tap()
        sleep(1)
        snapshot("01-Article-")
        roundLeftButtonButton.tap()
        scrollViewsQuery.childrenMatchingType(.StaticText).matchingIdentifier("Yes You Can!").elementBoundByIndex(1).tap()
        sleep(1)
        snapshot("02-Article-")
        roundLeftButtonButton.tap()
        
        
        
        
        
        
        
    }
    
}
