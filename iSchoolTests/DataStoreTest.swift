//
//  DataStoreTest.swift
//  iSchool
//
//  Created by Kári Helgason on 08/09/14.
//  Copyright (c) 2014 OrangeJam. All rights reserved.
//

import UIKit
import XCTest

class DataStoreTests: XCTestCase {
    
    class DataStoreMock: DataStore {
        // Fetch classes from test page instead of the real page
        override func fetchClasses() {
            let testDataPath = NSBundle(forClass: ParserTests.self).pathForResource("timetable_normal", ofType: "html")!
            let data = NSData(contentsOfFile: testDataPath)
            classes = Parser.parseClasses(data)
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostsNotificationOnFetchAssignments() {
        let expectation = expectationWithDescription("Should recieve notification")
        CredentialManager.sharedInstance.storeCredentials("test", "test")
        NSNotificationCenter.defaultCenter().addObserverForName(
            Notification.networkError.toRaw(),
            object: nil,
            queue: NSOperationQueue.mainQueue(),
            usingBlock: { _ in
                expectation.fulfill()
            }
        )
        DataStore.sharedInstance.fetchAssignments()
        waitForExpectationsWithTimeout(10, handler: { _ in
            
        })
    }
    
    func testGetClassesForDay() {
        let STOR = "Stöðuvélar og reiknanleiki"
        let ANDR = "App Development - Android"
        let dataStore = DataStoreMock()
        dataStore.fetchClasses()
        let classes = dataStore.getClassesForDay(WeekDay.Monday)
        XCTAssertEqual(classes.count, 5, "Classes for day not fetched correctly")
        if classes.count == 5 {
            XCTAssertEqual(classes[0].course, STOR, "First class on Monday should be STOR")
            XCTAssertEqual(classes[1].course, STOR, "Second class on Monday should be STOR")
            XCTAssertEqual(classes[2].course, ANDR, "Third class on Monday should be ANDR")
            XCTAssertEqual(classes[3].course, ANDR, "Fourth class on Monday should be ANDR")
            XCTAssertEqual(classes[4].course, ANDR, "Fifth class on Monday should be ANDR")
        } else {
            XCTFail("Could not check individual classes in testGetClassesForDay")
        }
    }
}