//
//  AtomicTests.swift
//  Execution
//
//  Created by Christian Otkjær on 01/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Execution

class AtomicTests: XCTestCase {

    func test_init()
    {
        let ai = Atomic(1)
        
        XCTAssertEqual(ai.value, 1)
    }
    
    func test_set()
    {
        let ai = Atomic(1)
        
        XCTAssertEqual(ai.value, 1)
        
        ai.value = 45
     
        XCTAssertEqual(ai.value, 45)
    }

    func test_with()
    {
        let ai = Atomic(1)
        
        XCTAssertEqual(ai.value, 1)
        
        ai.with { (v) in
            v.pointee += 2
        }
        
        XCTAssertEqual(ai.value, 3)
    }
    
    func testPerformanceExample()
    {
        self.measure { for _ in 0..<1000 { let _ = Atomic(1) } }
    }

}
