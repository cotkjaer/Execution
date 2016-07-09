//
//  NSOperation+Delay.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Delay

extension NSOperationQueue
{
    /** Adds `operation` to queue, but delays the operation `delay` seconds
    - parameter operation : The `NSOperation` to add
    - parameter delay : the number of seconds to delay the operation
    - 
 */
    public func addOperation(operation: NSOperation, withDelay seconds: Double)
    {
        if let delayOperation = DelayOperation(interval: seconds)
        {
            operation.addDependency(delayOperation)
            
            addOperations([delayOperation, operation], waitUntilFinished: false)
        }
        else
        {
            addOperation(operation)
        }
    }
}

// MARK: - DelayOperation

/// Simple synchronous NSOperation that will sleep for the given interval
private class DelayOperation : NSOperation
{
    let microseconds : useconds_t
    
    /**
    - parameter interval: Number of seconds to sleep
    - note : Returns nil if `interval < 0.001`
     */
    init?(interval: Double)
    {
        guard interval > 0.001 else { return nil }

        microseconds = useconds_t(interval * 1_000_000)
    }
    
    init(milliseconds: UInt)
    {
        microseconds = useconds_t(milliseconds * 1_000)
    }
    
    final override var asynchronous : Bool  { return false }

    final override func main()
    {
        guard microseconds > 1000 else { return }
        
        usleep(microseconds)
    }
}
