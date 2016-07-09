//
//  QueueTests.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class QueueTests: XCTestCase
{
    func test_add_operation_with_block_and_completion()
    {
        let queue = NSOperationQueue()
        
        let expect = expectationWithDescription("operation should be called")
        
        var i = 0
     
        queue.addOperationWithBlock({XCTAssertEqual(i, 0); i += 1}) { (cancelled) in
            XCTAssertEqual(cancelled, false)
            XCTAssertEqual(i, 1)
            expect.fulfill()
        }
        
        waitForExpectationsWithTimeout(10)
        { (error) in
            XCTAssertNil(error)
        }
    }
    
    
    func test_context()
    {
        
    }
}
