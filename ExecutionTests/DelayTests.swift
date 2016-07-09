//
//  DelayTests.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class DelayTests: XCTestCase
{
    func test_add_with_negative_delay()
    {
        let queue = NSOperationQueue()
        
        let expect = expectationWithDescription("operation should be called")

        queue.addOperation(NSBlockOperation(block:{ expect.fulfill() }), withDelay: -1)
        
        waitForExpectationsWithTimeout(0.01)
        { (error) in
            
            XCTAssertNil(error)
        }
    }
    
    
    func test_add_with_zero_delay()
    {
        let queue = NSOperationQueue()
        
        let expect = expectationWithDescription("operation should be called")
        
        queue.addOperation(NSBlockOperation(block:{ expect.fulfill() }), withDelay: 0)
        
        waitForExpectationsWithTimeout(0.01)
        { (error) in
            
            XCTAssertNil(error)
        }
    }
    
    func test_addDelayed()
    {
        let queue = NSOperationQueue()
        
        let expect = expectationWithDescription("operation should be called")
        
        var i = 0

        queue.addOperation(NSBlockOperation(block: { i = 3 }), withDelay: 0.01)

        queue.addOperation(NSBlockOperation(block: { XCTAssertEqual(i, 3); i = 1 }), withDelay: 0.02)

        queue.addOperation(NSBlockOperation(block: { expect.fulfill() }), withDelay: 0.03)

        queue.addOperation(NSBlockOperation(block: { XCTAssertEqual(i, 0) }))

        waitForExpectationsWithTimeout(1)
        { (error) in
        
            XCTAssertNil(error)
            
            XCTAssertEqual(i, 1)
        }
    }
}
