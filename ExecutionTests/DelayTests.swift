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
        let queue = OperationQueue()
        
        let expect = expectation(description: "operation should be called")

        queue.addOperation(BlockOperation(block:{ expect.fulfill() }), withDelay: -1)
        
        waitForExpectations(timeout: 0.01)
        { (error) in
            
            XCTAssertNil(error)
        }
    }
    
    
    func test_add_with_zero_delay()
    {
        let queue = OperationQueue()
        
        let expect = expectation(description: "operation should be called")
        
        queue.addOperation(BlockOperation(block:{ expect.fulfill() }), withDelay: 0)
        
        waitForExpectations(timeout: 0.01)
        { (error) in
            
            XCTAssertNil(error)
        }
    }
    
    func test_addDelayed()
    {
        let queue = OperationQueue()
        
        let expect = expectation(description: "operation should be called")
        
        var i = 0

        queue.addOperation(BlockOperation(block: { i = 3 }), withDelay: 0.1)

        queue.addOperation(BlockOperation(block: { XCTAssertEqual(i, 3); i = 1 }), withDelay: 0.2)

        queue.addOperation(BlockOperation(block: { expect.fulfill() }), withDelay: 0.3)

        queue.addOperation(BlockOperation(block: { XCTAssertEqual(i, 0) }))

        waitForExpectations(timeout: 1)
        { (error) in
        
            XCTAssertNil(error)
            
            XCTAssertEqual(i, 1)
        }
    }
}
