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
        
        XCTAssertEqual(1, val)
        XCTAssertEqual(1, res)
        XCTAssertEqual(res, val)
        
        XCTAssertTrue(lock.tryLock())
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        let expect = expectation(description: "operation should be called")

        queue.async(flags: .barrier, execute: {
            
            print ("before update")
            lock.execute({ val += 1 })
            print ("after update")
            
        } )

        queue.async(flags: .barrier, execute: {
            
            print ("before fullfill")
            
            lock.execute {
                
                XCTAssertEqual(res + 1 , val)
                expect.fulfill()
                }
            
            print ("after fulfill")
            
        } )

        XCTAssertEqual(res, val)

        lock.unlock()

        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error)
            
            XCTAssertEqual(res + 1 , val)
        }
    }
    
    func test_lock_protected_increment()
    {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 100
        
        let expect = expectation(description: "operation should be called")
        
        let lock = SpinLock()
        
        var i = 0
        
        let count = 1000
        
        var operations = (0..<count).map({ _ in BlockOperation(block:{
            lock.lock()
            i += 1
            lock.unlock()
        })})

        lock.lock()
        
        let fulfillOperation = BlockOperation(block: { expect.fulfill() })
        
        operations.forEach { fulfillOperation.addDependency($0) }
        
        operations.append(fulfillOperation)
        
        queue.addOperations(operations, waitUntilFinished: false)
        
        XCTAssertEqual(i, 0)
        
        lock.unlock()
        
        waitForExpectations(timeout: 10)
        { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(i, count)
        }
    }
}
