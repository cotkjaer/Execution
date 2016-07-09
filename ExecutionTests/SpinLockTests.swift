//
//  SpinLockTests.swift
//  Execution
//
//  Created by Christian Otkjær on 01/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class SpinLockTests: XCTestCase
{
    func test_lock()
    {
        let lock = SpinLock()
        
        lock.lock()
        
        XCTAssertFalse(lock.tryLock())
        
        lock.unlock()
        
        XCTAssertTrue(lock.tryLock())
        
        XCTAssertFalse(lock.tryLock())
        
        lock.unlock()
        
        var val : Int = 0
        
        let res = lock.execute({ () -> Int in val += 1; return val })
        
        XCTAssertEqual(res, val)
        
        XCTAssertTrue(lock.tryLock())
    }
    
    func test_lock_barrier()
    {
        let lock = SpinLock()
        
        var val : Int = 0
        
        let res = lock.execute({ () -> Int in val += 1; return val })
        
        XCTAssertEqual(res, val)
        
        XCTAssertTrue(lock.tryLock())
        
        let queue = dispatch_get_global_queue(0, 0)
        
        let expect = expectationWithDescription("operation should be called")

        dispatch_barrier_async(queue, {
            
            print ("before update")
            lock.execute({ val += 1 })
            print ("after update")
            
        } )

        dispatch_barrier_async(queue, {
            
            print ("before fullfill")
            
            lock.execute {
                
                XCTAssertEqual(res + 1 , val)
                expect.fulfill()
                }
            
            print ("after fulfill")
            
        } )

        XCTAssertEqual(res, val)

        lock.unlock()

        waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error)
            
            XCTAssertEqual(res + 1 , val)
        }
    }
}