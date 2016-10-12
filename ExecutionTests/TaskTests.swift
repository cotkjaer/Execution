//
//  TaskTests.swift
//  Execution
//
//  Created by Christian Otkjær on 18/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class TaskTests: XCTestCase
{
    func testExecute()
    {
        var runCounter = 0

        let task = Task({ runCounter += 1 })

        XCTAssertEqual(runCounter, 0)
        
        task.execute()
        task.execute()
        task.execute()
        task.execute()
        task.execute()
        
        XCTAssertEqual(runCounter, 5)
    }
    
    func testScheduleAfter()
    {
        var runCounter = 0
        
        let task = Task({ runCounter += 1 })
        
        XCTAssertEqual(runCounter, 0)
        
        task.schedule(1)
        task.schedule(-1)
        task.schedule(0)
        task.schedule(0.001)
        task.schedule(1.9)
        
        XCTAssertEqual(runCounter, 0)
        XCTAssertEqual(task.scheduled, 5)
        
        let expectation = self.expectation(description: "scheduled closure did run")
        
        let fulfillTask = Task({ XCTAssertEqual(runCounter, 5); XCTAssertEqual(task.scheduled, 0); expectation.fulfill() })
        
        fulfillTask.schedule(2)
        
        waitForExpectations(timeout: 3) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testRescheduleAfter()
    {
        var runCounter = 0
        
        let task = Task({ runCounter += 1 })
        
        XCTAssertEqual(runCounter, 0)
        
        task.schedule(0.2)
        task.schedule(0.2)
        task.schedule(1.5)
        task.schedule(1.5)
        task.schedule(1.5)
        
        XCTAssertEqual(runCounter, 0)
        XCTAssertEqual(task.scheduled, 5)
        
        let rescheduleTask = Task({ XCTAssertEqual(runCounter, 2); XCTAssertEqual(task.scheduled, 3); task.reschedule(0.2); task.schedule(0.1) })

        rescheduleTask.schedule(1)
        
        XCTAssertEqual(runCounter, 0)
        XCTAssertEqual(task.scheduled, 5)

        let expectation = self.expectation(description: "scheduled closure did run")
        
        let fulfillTask = Task({ XCTAssertEqual(runCounter, 4); XCTAssertEqual(task.scheduled, 0); expectation.fulfill() })
        
        fulfillTask.schedule(5)
        
        waitForExpectations(timeout: 10) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testScheduleOn()
    {
        var runCounter = 0
        
        let task = Task({ runCounter += 1 })
        
        XCTAssertEqual(runCounter, 0)
        
        
        task.schedule(Date().addingTimeInterval(-2))
        task.schedule(Date().addingTimeInterval(0.4))
        task.schedule(Date().addingTimeInterval(0.4))
        task.schedule(Date().addingTimeInterval(0.4))
        task.schedule(Date().addingTimeInterval(0.4))
        
        XCTAssertEqual(runCounter, 0)
        
        XCTAssertEqual(task.scheduled, 5)
        
        let expectation = self.expectation(description: "scheduled closure did run")
        
        let fulfillTask = Task({ XCTAssertEqual(runCounter, 5); XCTAssertEqual(task.scheduled, 0); expectation.fulfill() })
        
        fulfillTask.schedule(2)
        
        waitForExpectations(timeout: 3) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testUnschedule()
    {
        var runCounter = 0
        
        let task = Task({ runCounter += 1 })
        
        XCTAssertEqual(runCounter, 0)
        
        task.schedule(1)
        task.schedule(0.5)
        
        XCTAssertEqual(runCounter, 0)
        XCTAssertEqual(task.scheduled, 2)
        
        task.unschedule()

        XCTAssertEqual(runCounter, 0)
        XCTAssertEqual(task.scheduled, 0)

        task.execute()
        XCTAssertEqual(runCounter, 1)
        
        task.schedule(0.1)
        task.schedule(0.2)

        let expectation = self.expectation(description: "scheduled closure did run")

        let fulfillTask = Task({ XCTAssertEqual(runCounter, 3); expectation.fulfill() })
        
        fulfillTask.schedule(2)
        
        waitForExpectations(timeout: 3) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testReschedule()
    {
        let expectation = self.expectation(description: "scheduled closure did run")
        
        var runCounter = 0
        
        let fulfillTask = Task({ expectation.fulfill() })
        
        let task = Task({
            runCounter += 1
            XCTAssertEqual(runCounter, 1)
            fulfillTask.reschedule(1)
            }
        )
        
        task.reschedule(100)
        task.reschedule(4)
        task.reschedule(1)
        task.reschedule(1)
        
        var failTask : Task? = Task({ XCTFail("Must not run") })
        
        XCTAssertNotNil(failTask)
        
        failTask?.reschedule(1)
        failTask?.unschedule()
        
        failTask?.reschedule(1)
        failTask = nil
        
        Task({ XCTFail("Must not run") }).reschedule(1)
        
        waitForExpectations(timeout: 10) { error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}
