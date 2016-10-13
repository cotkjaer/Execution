//
//  AsyncTests.swift
//  Execution
//
//  Created by Christian Otkjær on 18/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class AsyncTests: XCTestCase
{
    func test_delay_seconds()
    {
        let expectation = self.expectation(description: "delayed closure did run")
        
        let now = NSDate()
        var when = NSDate()
        
        delay(3) {
            
            when = NSDate()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4)
        {
            XCTAssertNil($0)
            
            XCTAssertGreaterThan(when.timeIntervalSinceReferenceDate, now.timeIntervalSinceReferenceDate + 2)
        }
    }
    
    func testDelay()
    {
        let expectation = self.expectation(description: "delayed closure did run")

        var counter = 0
        
        delay(0.2) {
            
            counter += 1
            
            XCTAssertGreaterThan(counter, 1)
            
            expectation.fulfill()
        }
        
        XCTAssertEqual(counter, 0)
        
        counter += 1

        XCTAssertEqual(counter, 1)

        waitForExpectations(timeout: 1) { error in

            if let error = error
            {
                print("Error: \(error.localizedDescription)")
            }
            
            XCTAssertEqual(counter, 2)
        }
    }
}
